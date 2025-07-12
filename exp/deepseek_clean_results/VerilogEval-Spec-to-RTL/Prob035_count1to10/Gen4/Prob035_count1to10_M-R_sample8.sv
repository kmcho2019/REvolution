module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] q_reg;
wire [3:0] next_q;

// Combinational next state logic
assign next_q = reset ? 4'b0001 :         // Reset condition
                (q_reg[3] & q_reg[1]) ? 4'b0001 :  // Wrap at 10
                q_reg + 1;                // Normal increment

// Sequential state storage
always @(posedge clk) begin
    q_reg <= next_q;
end

assign q = q_reg;

endmodule