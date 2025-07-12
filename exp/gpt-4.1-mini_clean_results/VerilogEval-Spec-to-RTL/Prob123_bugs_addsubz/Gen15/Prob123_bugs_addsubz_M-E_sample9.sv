module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] operand_b;
    wire [8:0] result_ext;

    // Select b or two's complement of b based on do_sub signal
    assign operand_b = do_sub ? (~b + 8'd1) : b;

    // Extend a and operand_b to 9 bits to catch overflow if needed
    assign result_ext = {1'b0, a} + {1'b0, operand_b};

    always @(*) begin
        out = result_ext[7:0];
        result_is_zero = (out == 8'b0);
    end

endmodule