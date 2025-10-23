// Define the TopModule with a novel architecture using packed vectors
module TopModule(
    input  logic [3:0] p1, // p1a, p1b, p1c, p1d
    input  logic [3:0] p2, // p2a, p2b, p2c, p2d
    output logic p1y,
    output logic p2y
);
// Apply NAND operation using bitwise operators on packed vectors
assign p1y = ~(&p1); // ~ is bitwise NOT, & is bitwise AND across vector
assign p2y = ~(&p2);
endmodule