module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg enable;
wire [63:0] next_Q;

// Enable logic - freeze counter at extreme states
always @(*) begin
    enable = ~((&Q) || (~|Q));
end

// Two-stage pipelined shift with balanced logic
assign next_Q = {~Q[0], Q[63:33], Q[32:1]};

always @(posedge clk) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else if (enable) begin
        Q <= next_Q;
    end
end

endmodule