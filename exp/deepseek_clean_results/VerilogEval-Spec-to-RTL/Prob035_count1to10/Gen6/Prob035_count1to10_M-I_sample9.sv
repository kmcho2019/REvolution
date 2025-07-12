module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] q_reg;
wire [3:0] next_q;

// Combinational next state logic
assign next_q = reset ? 4'd1 :            // Reset to 1
                (q_reg == 4'd10) ? 4'd1 : // Wrap at 10
                q_reg + 1;                // Normal increment

// Sequential state storage
always @(posedge clk) begin
    q_reg <= next_q;
end

assign q = q_reg;

endmodule