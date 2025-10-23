module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [63:0] next_Q;

// Combinational logic to generate next state
assign next_Q = {~Q[0], Q[63:1]};

// Sequential update of Q
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: Set Q to 0
        Q <= 64'd0;
    end else begin
        // Update Q on rising edge of clk
        Q <= next_Q;
    end
end

endmodule