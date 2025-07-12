module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    wire carry_out;
    wire [9:0] next_val;

    assign {carry_out, next_val} = q + 10'd1;

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0;
        end else if (carry_out) begin
            // next_val == 1000, wrap to zero
            q <= 10'd0;
        end else begin
            q <= next_val;
        end
    end

endmodule