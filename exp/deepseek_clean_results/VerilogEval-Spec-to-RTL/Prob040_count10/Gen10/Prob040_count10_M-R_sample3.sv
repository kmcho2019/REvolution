module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

wire [3:0] next_q;
reg [3:0] q_reg;

// Next state logic
assign next_q = reset ? 4'b0000 : 
                (q_reg == 4'b1001) ? 4'b0000 : 
                q_reg + 1'b1;

// Register update (DFF implementation)
assign q = q_reg;
always @(posedge clk) begin
    q_reg <= next_q;
end

endmodule