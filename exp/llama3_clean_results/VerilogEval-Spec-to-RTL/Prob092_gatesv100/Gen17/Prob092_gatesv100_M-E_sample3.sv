module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Internal signals for shifted inputs
    reg [99:0] in_shifted_left;
    reg [99:0] in_shifted_right;
    reg [99:0] inWrapped;

    // Calculate the shifted inputs
    always @(*) begin
        in_shifted_left = {in[98:0], 1'b0}; // Shift left by one bit
        in_shifted_right = {1'b0, in[99:1]}; // Shift right by one bit
        inWrapped = {in[0], in[99:1]}; // Wrapped around for out_different
    end

    // Perform bitwise operations
    assign out_both = in & in_shifted_left;
    assign out_any = in | in_shifted_right;
    assign out_different = in ^ inWrapped;

endmodule