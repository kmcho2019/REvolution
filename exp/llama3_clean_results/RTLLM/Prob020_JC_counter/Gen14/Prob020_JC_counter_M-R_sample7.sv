// Define the module for the 64-bit Johnson counter
module JC_counter(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    output reg [63:0] Q  // 64-bit register representing the current count value
);

// Combinational logic to determine the next state (next_Q)
wire [63:0] next_Q;
assign next_Q = {Q[0]? 1'b0 : 1'b1, Q[63:1]};

// Synchronous reset to update Q
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Q <= 64'd0;
    end else begin
        Q <= next_Q;
    end
end

endmodule