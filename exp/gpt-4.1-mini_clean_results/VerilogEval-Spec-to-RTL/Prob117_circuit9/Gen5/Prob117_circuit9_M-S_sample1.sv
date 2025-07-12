module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;
    end else begin
        // Increment q modulo 7 (states 0..6)
        q <= (q == 3'd6) ? 3'd0 : q + 3'd1;
    end
end

endmodule