module TopModule(
    input  [99:0] a,
    input  [99:0] b,
    input  sel,
    output [99:0] out
);

    wire [99:0] mask_a;
    wire [99:0] mask_b;

    assign mask_a = {100{~sel}}; // Create a mask where all bits are 1 if sel is 0
    assign mask_b = {100{sel}};  // Create a mask where all bits are 1 if sel is 1

    assign out = (a & mask_a) | (b & mask_b);

endmodule