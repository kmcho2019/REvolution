module JC_counter(
    input clk,
    input rst_n,
    output reg [63:0] Q
);

wire [63:0] next_Q;

// Combinational logic for next state
assign next_Q = {~Q[0], Q[63:1]};

// Sequential logic for state storage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= 64'b0;
    else
        Q <= next_Q;
end

endmodule