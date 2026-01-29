import 'package:flutter/material.dart';
import 'package:notification/notification_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.location_on, color: Colors.green, size: 18),
                Text(" ABCD, New Delhi", style: TextStyle(color: Colors.black, fontSize: 14)),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
          ],
        ),
    
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Search Bar
         // 1. Search Bar + Action Icons Row
SliverToBoxAdapter(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Row(
      children: [
        // Search Bar - Now occupies maximum possible space
        Expanded(
          child: SizedBox(
            height: 45,
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: "Search for products/stores",
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                suffixIcon: const Icon(Icons.search, color: Colors.green, size: 20),
                filled: true,
                fillColor: Colors.grey[100],
                
                // Reduced vertical padding to keep text centered
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        
        // Very small gap between search bar and first icon
        const SizedBox(width: 2), 

        // Notification Icon
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 35), // Fixed width to reduce gap
              visualDensity: VisualDensity.compact,
              onPressed: () {Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationPage()),
    );
  },
              icon: const Icon(Icons.notifications_none, color: Colors.redAccent, size: 26),
            ),
            Positioned(
              right: 4,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                child: const Text(
                  "2",
                  style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),

        // Price Tag Icon
        IconButton(
  padding: EdgeInsets.zero,
  constraints: const BoxConstraints(minWidth: 35),
  visualDensity: VisualDensity.compact,
  onPressed: () {},
  // Using an image from assets instead of Icons.label
  icon: Image.asset(
    'assets/images/pricetag.jpg', // Your custom icon path
    width: 24, 
    height: 24,
   // color: Colors.orange, // This only works if your PNG is a single color/silhouette
  ),
),
      /*  IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 35), // Fixed width to reduce gap
          visualDensity: VisualDensity.compact,
          onPressed: () {},
          icon: const Icon(Icons.label_outline, color: Colors.orange, size: 26),
        ),*/
      ],
    ),
  ),
),

          // 2. Category Grid
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text("What would you like to do today?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildCategoryItem(_categories[index],index),
                childCount: _categories.length,
              ),
            ),
          ),

          // 3. Discount Banner
         SliverToBoxAdapter(
  child: Container(
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.green[400],
      borderRadius: BorderRadius.circular(15),
    ),
    child: Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("DISCOUNT\n25% ALL\n FRUITS",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: const Size(80, 40),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("CHECK NOW",
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        Positioned(
          right: -10,
          bottom: 0,
          top: 0,
          child: Image.asset('assets/images/fruit.jpg',
              width: 150, fit: BoxFit.contain),
        ),
      ],
    ),
  ),
),

          // 4. Trending Section
   

_buildSectionHeader("Trending"),
SliverToBoxAdapter(
  child: SizedBox(
    height: 180, // Height enough for 2 rows of cards
    child: GridView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 6, // Total items
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // This creates the 2 rows
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.38, // Adjust this to control card width
      ),
      itemBuilder: (context, index) => _buildTrendingCard(),
    ),
  ),
),
  _buildSectionHeader("Craze Deals"),
SliverToBoxAdapter(
  child: Container(
    margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
    height: 148,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      gradient: const LinearGradient(
        colors: [Color(0xFF040404), Color(0xFF121212)],
      ),
    ),
    child: Row(
      children: [
        // ----  text  ----
        const Expanded(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              
                SizedBox(height: 6),
                Text("Customer favourite\nTop supermarkets",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
        ),
        // ----  image  ----
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8),
            child: Image.asset('assets/images/veg.jpg',
                height: 110, fit: BoxFit.contain),
          ),
        ),
      ],
    ),
  ),
),



SliverToBoxAdapter(
  child: Container(
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 135, 242, 135),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Refer and Earn",
                  style: TextStyle(fontSize: 18,)),
              const Text("Invite your friends & earn 15% off",
                  style: TextStyle(fontSize: 13)),
              const SizedBox(height: 10),
           
            ],
          ),
        ),
        const SizedBox(width: 12),
        Image.asset('assets/images/gift.png', height: 80),
      ],
    ),
  ),
),
          // 5. Nearby Stores
          _buildSectionHeader("Nearby stores"),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildStoreItem(),
              childCount: 3,
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildSectionHeader(String title) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Text("See all", style: TextStyle(color: Colors.green)),
          ],
        ),
      ),
    );
  }
Widget _buildCategoryItem(Map<String, dynamic> cat, int index) {
  final showBadge = const {0, 1, 2, 7}.contains(index); // 1st,2nd,3rd,8th

  return Column(
    children: [
      Stack(
        clipBehavior: Clip.none,
        children: [
          // main icon container (unchanged)
          Container(
            padding: const EdgeInsets.all(12),
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Image.asset(cat['image'], fit: BoxFit.contain),
          ),

          // purple 10 % OFF badge drawn with widgets
          if (showBadge)
            Positioned(
              right: -8,
              top: -8,
              child: Transform.rotate(
                angle: 0, // slight tilt like the picture
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B3FF2), // exact purple
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '10% OFF',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      const SizedBox(height: 8),
      Text(
        cat['title'],
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
        maxLines: 2,
      ),
    ],
  );
}
Widget _buildTrendingCard() {
  return SizedBox(
    // Wrapping in SizedBox helps the Grid define boundaries
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Image Container
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/icecream.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Text Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Mithas Bhandar",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                "Sweets, North Indian",
                style: const TextStyle(fontSize: 10, color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                "(Store location) | 6.4 kms",
                style: const TextStyle(fontSize: 10, color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, size: 12, color: Colors.grey),
                  const Text(
                    " 4.1 | 45 mins",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    ),
  );
}

  Widget _buildStoreItem() {
    return ListTile(
    leading: ClipRRect(
  borderRadius: BorderRadius.circular(8),
  child: Image.asset(
    'assets/images/store.jpg',   // <-- your picture
    width: 60,
    height: 60,
    fit: BoxFit.cover,
  ),
),
      title: const Text("Freshly Baker"),
      subtitle: const Text("Sweets, North Indian \nSite No-1 | 6.4 km"),
      trailing: const Text("4.1 \n45 mins", textAlign: TextAlign.right, style: TextStyle(color: Colors.orange)),
      isThreeLine: true,
    );
  }
}

// Mock Data
final List<Map<String, dynamic>> _categories = [
  {'title': 'Food Delivery', 'image': 'assets/images/burger.jpg'},
  {'title': 'Medicines', 'image': 'assets/images/medicine.jpg'},
  {'title': 'Pet Supplies', 'image': 'assets/images/pet.jpg'},
  {'title': 'Gifts', 'image': 'assets/images/gift.jpg'},
  {'title': 'Meat', 'image': 'assets/images/meat.jpg'},
  {'title': 'Cosmetic', 'image': 'assets/images/cosmetic.jpg'},
  {'title': 'Stationery', 'image': 'assets/images/stationery.jpg'},
  {'title': 'Stores', 'image': 'assets/images/ice.jpg'},
];