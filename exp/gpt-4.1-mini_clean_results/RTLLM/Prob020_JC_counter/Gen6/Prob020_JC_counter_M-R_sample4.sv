module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

reg [63:0] next_Q;

always @(*) begin
    // If Q[0] is 0, insert 1 at MSB; else insert 0 at MSB
    next_Q = {~Q[0], Q[63:1]};
end

always @(posedge clk) begin
    if (!rst_n)
        Q <= 64'b0;
    else
        Q <= next_Q;
end

endmodule