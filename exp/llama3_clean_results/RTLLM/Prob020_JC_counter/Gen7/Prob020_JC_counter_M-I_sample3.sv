module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [63:0] next_Q; // Temporary variable to hold the next state

always @(*) begin
    if (~Q[0]) begin
        next_Q = {1'b1, Q[63:1]}; // Increment the counter by shifting right and appending 1
    end else begin
        next_Q = {1'b0, Q[63:1]}; // Decrement the counter by shifting right and appending 0
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Q <= '0; // Reset the counter to 0 when rst_n is low
    end else begin
        Q <= next_Q; // Update the counter with the next state
    end
end

endmodule