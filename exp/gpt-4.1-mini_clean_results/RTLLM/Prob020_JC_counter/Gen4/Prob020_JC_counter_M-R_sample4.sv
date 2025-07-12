module JC_counter (
    input  wire        clk,
    input  wire        rst_n,
    output reg  [63:0] Q
);

reg [63:0] next_Q;

always @(*) begin
    if (Q[0] == 1'b0)
        next_Q = {1'b1, Q[63:1]};
    else
        next_Q = {1'b0, Q[63:1]};
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= 64'b0;
    else
        Q <= next_Q;
end

endmodule