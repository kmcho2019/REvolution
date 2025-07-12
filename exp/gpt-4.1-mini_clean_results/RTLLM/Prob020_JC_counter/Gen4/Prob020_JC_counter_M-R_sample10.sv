module JC_counter(
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

reg [63:0] next_Q;

always @* begin
    // Calculate feedback bit based on Q[0]
    // If Q[0] == 0, feedback = 1; else feedback = 0
    next_Q = { (Q[0] == 1'b0) ? 1'b1 : 1'b0, Q[63:1] };
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= 64'b0;
    else
        Q <= next_Q;
end

endmodule