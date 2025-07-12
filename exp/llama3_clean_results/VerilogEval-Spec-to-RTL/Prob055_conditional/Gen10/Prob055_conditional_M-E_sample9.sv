module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // First level of comparison and swap
    wire [7:0] ab;
    wire [7:0] cd;
    assign ab = (a < b) ? a : b;
    assign cd = (c < d) ? c : d;

    // Second level of comparison and swap
    wire [7:0] ac;
    wire [7:0] bd;
    assign ac = (ab < cd) ? ab : cd;
    assign bd = (ab > cd) ? ab : cd;

    // Third level of comparison and swap
    wire [7:0] bc;
    assign bc = (bd < ac) ? bd : ac;

    // Extract the minimum value
    assign min = (ac < bc) ? ac : bc;

endmodule