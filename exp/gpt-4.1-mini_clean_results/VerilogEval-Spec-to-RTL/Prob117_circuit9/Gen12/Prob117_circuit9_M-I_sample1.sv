module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] next_q;

always @(*) begin
    if (a)
        next_q = 3'd4;
    else begin
        // Increment q modulo 7 (0 to 6)
        // When q == 6, next_q wraps to 0, else increment by 1
        next_q = (q == 3'd6) ? 3'd0 : q + 3'd1;
    end
end

always @(posedge clk) begin
    q <= next_q;
end

initial q = 3'd4;

endmodule