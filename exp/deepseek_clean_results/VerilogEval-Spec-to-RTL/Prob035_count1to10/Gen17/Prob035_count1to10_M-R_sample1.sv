module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] q_reg;
assign q = q_reg;

wire [3:0] next_q = reset ? 4'b0001 :        // Reset to 1
                   (q_reg == 4'b1010) ? 4'b0001 :  // Wrap around at 10
                   q_reg + 4'b0001;          // Increment

always @(posedge clk) begin
    q_reg <= next_q;
end

endmodule