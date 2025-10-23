module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] next_q;

always @(*) begin
    if (q == 4'b1010)  // Explicit comparison for value 10
        next_q = 4'b0001;
    else
        next_q = q + 1;
end

always @(posedge clk) begin
    if (reset)
        q <= 4'b0001;
    else
        q <= next_q;
end

endmodule