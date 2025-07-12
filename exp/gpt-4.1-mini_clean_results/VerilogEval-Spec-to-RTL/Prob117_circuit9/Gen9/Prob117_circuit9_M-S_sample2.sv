module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;
    end else begin
        // Increment q modulo 7 with start at 4
        q <= (q == 3'd6) ? 3'd0 : (q + 3'd1);
        // Correct wrap-around for values outside 0-6
        if (q > 3'd6)
            q <= 3'd4;
    end
end

endmodule