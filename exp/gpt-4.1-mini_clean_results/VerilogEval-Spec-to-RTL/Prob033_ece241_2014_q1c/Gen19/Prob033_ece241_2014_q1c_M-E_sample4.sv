module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    // Declare signed extended versions of inputs
    wire signed [8:0] a_ext = {a[7], a};
    wire signed [8:0] b_ext = {b[7], b};
    // Perform signed addition
    wire signed [8:0] sum_ext = a_ext + b_ext;

    // Assign the lower 8 bits as output sum
    assign s = sum_ext[7:0];

    // Overflow occurs if sign bit [8] differs from sum MSB [7]
    assign overflow = sum_ext[8] ^ sum_ext[7];

endmodule