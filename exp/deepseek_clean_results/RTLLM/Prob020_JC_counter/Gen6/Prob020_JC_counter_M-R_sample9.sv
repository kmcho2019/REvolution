module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

wire [63:0] next_Q;

// Combinational logic for next state
assign next_Q = (!rst_n) ? 64'b0 :         // Reset condition
                (Q[0] == 1'b0) ? {1'b1, Q[63:1]} :  // Increment phase
                {1'b0, Q[63:1]};           // Decrement phase

// Sequential register update
always @(posedge clk or negedge rst_n) begin
    Q <= next_Q;
end

endmodule