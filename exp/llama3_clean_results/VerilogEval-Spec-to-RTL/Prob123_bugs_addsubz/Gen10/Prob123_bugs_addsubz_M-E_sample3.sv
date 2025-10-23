module adder_subtractor (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output reg result_is_zero
);

    wire [7:0] b_inv;
    assign b_inv = ~b;

    wire [7:0] b_selector;
    assign b_selector = do_sub ? (b_inv + 1) : b;

    assign out = a + b_selector;

    always @(*) begin
        if (out == 8'd0) begin
            result_is_zero = 1'b1;
        end else begin
            result_is_zero = 1'b0;
        end
    end

endmodule