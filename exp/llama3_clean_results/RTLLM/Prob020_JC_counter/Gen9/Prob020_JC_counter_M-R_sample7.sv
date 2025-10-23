module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [63:0] next_Q;

// Combinational logic to calculate the next state
assign next_Q = (Q[0] == 1'b0) ? {1'b1, Q[63:1]} : {1'b0, Q[63:1]};

// Sequential update of the state
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Q <= 64'd0; // Reset the counter to 0 when rst_n is low
    end else begin
        Q <= next_Q; // Update Q with the next state
    end
end

endmodule