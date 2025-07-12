module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_complement;
    wire [7:0] b_muxed;
    wire [8:0] sum_ext;

    // Calculate two's complement of b when do_sub is asserted
    assign b_complement = ~b;
    assign b_muxed = do_sub ? b_complement : b;

    // Perform addition with carry-in = do_sub (1 if subtract, 0 if add)
    assign sum_ext = {1'b0, a} + {1'b0, b_muxed} + do_sub;

    always @(*) begin
        out = sum_ext[7:0];
        result_is_zero = (out == 8'b0) ? 1'b1 : 1'b0;
    end

endmodule