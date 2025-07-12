module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4; // Hold q=4 when a=1
    end else begin
        // Increment modulo 7: if q=6 go to 0 else q+1
        q <= (q == 3'd6) ? 3'd0 : (q + 3'd1);
    end
end

endmodule