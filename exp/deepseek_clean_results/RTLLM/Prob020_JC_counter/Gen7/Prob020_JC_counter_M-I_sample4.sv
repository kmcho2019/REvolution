module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg clk_enable;
wire [63:0] next_Q;

// Clock gating control
always @(*) begin
    clk_enable = !((Q == 64'h0) || (Q == 64'hFFFFFFFFFFFFFFFF));
end

// Next state logic
assign next_Q = (Q[0] == 1'b0) ? {1'b1, Q[63:1]} : {1'b0, Q[63:1]};

// Pipelined register update
always @(posedge clk) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end
    else if (clk_enable) begin
        Q <= next_Q;
    end
end

endmodule