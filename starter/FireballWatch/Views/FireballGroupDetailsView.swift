/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI
import MapKit

struct FireballGroupDetailsView: View {
  let fireballGroup: FireballGroup
  var mapRegion: MKCoordinateRegion {
    let span = MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)

    guard let fireball = fireballGroup.fireballs?.anyObject() as? Fireball else {
      return MKCoordinateRegion(center: CLLocationCoordinate2D(), span: span)
    }

    let coordinates = CLLocationCoordinate2D(latitude: fireball.latitude, longitude: fireball.longitude)
    return MKCoordinateRegion(center: coordinates, span: span)
  }

  var mapAnnotations: [FireballAnnotation] {
    guard let fireballs = fireballGroup.fireballs else {
      return []
    }

    return fireballs.compactMap {
      guard let fireball = $0 as? Fireball else {
        return nil
      }

      return FireballAnnotation(
        coordinates: CLLocationCoordinate2D(
          latitude: fireball.latitude,
          longitude: fireball.longitude),
        color: fireball.impactEnergyMagnitude.color)
    }
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Fireballs: \(fireballGroup.fireballs?.count ?? 0)")
        .padding()
      FireballMapView(mapRegion: mapRegion, annotations: mapAnnotations)
    }
      .navigationBarTitle(Text(fireballGroup.name ?? "Fireball Group"))
  }
}

struct FireballGroupDetails_Previews: PreviewProvider {
  static var group: FireballGroup {
    let controller = PersistenceController.preview
    return controller.makeRandomFireballGroup(context: controller.viewContext)
  }

  static var previews: some View {
    FireballGroupDetailsView(fireballGroup: group)
  }
}