module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg clk_en;
wire [63:0] next_Q;

// Clock gating control
always @(*) begin
    clk_en = (Q != 64'h0) && (Q != {64{1'b1}});
end

// Next state logic (pipelined shift)
assign next_Q = {~Q[31:0][0], Q[63:32], Q[31:1]};

// Registered logic with clock gating
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'h0;
    end
    else if (clk_en) begin
        Q <= next_Q;
    end
end

endmodule