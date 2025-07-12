module TopModule (
    input clk,            // Added clock for power optimization
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] b_adj = do_sub ? ~b : b;
    wire [7:0] sum = a + b_adj + do_sub;

    always @(posedge clk) begin
        out <= sum;
        result_is_zero <= (sum == 8'b0);  // Only updates on clock edges
    end

endmodule