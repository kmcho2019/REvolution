module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

wire [3:0] q_next;
reg [3:0] q_reg;

// Combinational next state logic
assign q_next = reset ? 4'b0000 :       // Synchronous reset
                (q_reg[3] & q_reg[0]) ? 4'b0000 :  // Check for 9 (1001)
                q_reg + 1'b1;           // Normal increment

// Sequential state update using continuous assignment
assign q = q_reg;

always @(posedge clk) begin
    q_reg <= q_next;
end

endmodule