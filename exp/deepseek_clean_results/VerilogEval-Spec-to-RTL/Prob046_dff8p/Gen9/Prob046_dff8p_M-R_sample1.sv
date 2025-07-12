module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

localparam RESET_VAL = 8'h34;
reg [7:0] q_reg;
reg [7:0] next_q;

// Combinational logic for next state
always @(*) begin
    next_q = reset ? RESET_VAL : d;
end

// Edge-triggered behavior using continuous assignment
assign q = q_reg;

// Register update on negative clock edge
always @(negedge clk) begin
    q_reg <= next_q;
end

endmodule