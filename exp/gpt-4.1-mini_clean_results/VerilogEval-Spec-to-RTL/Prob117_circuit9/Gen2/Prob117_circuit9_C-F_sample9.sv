module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4; // Force q=4 when a=1
    end else begin
        // If q is valid (0 to 6), increment modulo 7; else reset to 4
        if (q < 3'd7)
            q <= (q == 3'd6) ? 3'd0 : q + 3'd1;
        else
            q <= 3'd4;
    end
end

endmodule