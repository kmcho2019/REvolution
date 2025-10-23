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

    // Concatenate all inputs into a single 30-bit wire
    wire [29:0] combined_inputs = {a, b, c, d, e, f};

    // Create the final 32-bit concatenation with two appended '1' bits at LSB
    wire [31:0] combined_with_append = {combined_inputs, 2'b11};

    // Assign outputs by slicing combined_with_append
    assign w = combined_with_append[31:24];
    assign x = combined_with_append[23:16];
    assign y = combined_with_append[15:8];
    assign z = combined_with_append[7:0];

endmodule