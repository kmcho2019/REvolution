module JC_counter (
    input clk,
    input rst_n,
    output [63:0] Q
);

reg [63:0] state_reg;
wire [63:0] next_state;

// Combinational logic for next state
assign next_state = !rst_n ? 64'b0 :           // Reset condition
                   (state_reg[0] == 1'b0) ? {1'b1, state_reg[63:1]} :  // Shift right with 1
                   {1'b0, state_reg[63:1]};    // Shift right with 0

// State register update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state_reg <= 64'b0;
    end else begin
        state_reg <= next_state;
    end
end

// Output assignment
assign Q = state_reg;

endmodule