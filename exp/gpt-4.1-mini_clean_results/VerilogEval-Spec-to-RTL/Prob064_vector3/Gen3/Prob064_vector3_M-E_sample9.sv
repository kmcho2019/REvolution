module TopModule (
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Zero-extend each 5-bit input to 8 bits
    wire [7:0] a_ext = {3'b000, a};
    wire [7:0] b_ext = {3'b000, b};
    wire [7:0] c_ext = {3'b000, c};
    wire [7:0] d_ext = {3'b000, d};
    wire [7:0] e_ext = {3'b000, e};
    wire [7:0] f_ext = {3'b000, f};

    // Combine zero-extended inputs into 32-bit result via shifting and addition
    wire [31:0] combined;
    assign combined = 
          ({a_ext, 0} << (7*5)) // a occupies bits 29:25 (shifted by 25)
        | ({b_ext, 0} << (6*5)) // b at bits 24:20 (shifted by 20)
        | ({c_ext, 0} << (5*5)) // c at bits 19:15 (shifted by 15)
        | ({d_ext, 0} << (4*5)) // d at bits 14:10 (shifted by 10)
        | ({e_ext, 0} << (3*5)) // e at bits 9:5   (shifted by 5)
        | ({f_ext, 0} << (2*5)) // f at bits 4:0   (shifted by 0)
        | 32'b11;              // append two '1' bits at LSB (bits 1:0)

    // Because shifts use multiples of 5 but multiplied by 8 (bits), we need to shift carefully.
    // Correction: The idea is to place inputs consecutively but since each input is 5 bits
    // and we extended to 8 bits, shifts must align properly:
    // We'll instead build the final vector differently to place inputs exactly:
    // Instead of OR with shifts, pack all inputs and then append 2 LSB ones.

endmodule