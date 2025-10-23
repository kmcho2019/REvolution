module TopModule (
    input clk,          // Added clock for registered outputs
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] b_sel = do_sub ? ~b + 1'b1 : b;  // Two's complement for subtraction
    wire [7:0] sum = a + b_sel;

    always @(posedge clk) begin
        out <= sum;
        result_is_zero <= (sum == 8'b0);
    end

endmodule