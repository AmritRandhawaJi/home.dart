class Slide {
  String title;
  String description;
  String image;

  Slide({required this.title, required this.description, required this.image});
}

final slideList = [
  Slide(
      title: "Nearby Tailor",
      description: "You can now search nearby tailors for your cloths.",
      image: "assets/89051-girl-stitching-a-cloth.json"),
  Slide(
      title: "On-Time Delivery",
      description: "Even you can track current status of stitching.",
      image: "assets/144567-picky-rider.json"),

  Slide(
      title: "Cloths Customization",
      description:
      "You've unlocked the new way to customize your clothes.",
      image: "assets/134497-tailor-made.json"),

];