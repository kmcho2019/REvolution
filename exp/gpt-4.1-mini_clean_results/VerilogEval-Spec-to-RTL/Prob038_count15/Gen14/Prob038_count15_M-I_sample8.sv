module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] next_q;

always @(*) begin
    next_q = q + 1;  // Simple binary increment for improved timing
end

always @(posedge clk) begin
    if (reset)
        q <= 4'b0000;
    else
        q <= next_q;
end

endmodule