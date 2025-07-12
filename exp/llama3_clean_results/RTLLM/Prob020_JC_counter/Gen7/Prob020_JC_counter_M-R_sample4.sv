module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Combinational logic to generate the next state
wire [63:0] next_Q;
assign next_Q = (Q[0] == 1'b0) ? {1'b1, Q[63:1]} : {1'b0, Q[63:1]};

// Sequential logic to update the current state
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter to 0 when rst_n is low
        Q <= 64'd0;
    end else begin
        // Update the counter value
        Q <= next_Q;
    end
end

endmodule