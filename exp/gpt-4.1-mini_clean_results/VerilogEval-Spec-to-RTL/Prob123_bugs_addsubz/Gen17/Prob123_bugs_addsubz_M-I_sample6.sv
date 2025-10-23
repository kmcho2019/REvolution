module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_xor;
    wire [8:0] sum;

    assign b_xor = b ^ {8{do_sub}};    // Conditional invert B bits for subtraction

    // Perform addition: a + (b XOR do_sub) + do_sub
    assign sum = {1'b0, a} + {1'b0, b_xor} + do_sub;

    always @(*) begin
        out = sum[7:0];
        result_is_zero = ~|sum[7:0];  // zero flag by reduction NOR
    end

endmodule