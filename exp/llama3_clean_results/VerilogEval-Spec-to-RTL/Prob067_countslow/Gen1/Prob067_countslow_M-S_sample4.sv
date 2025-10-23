module TopModule (
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000; // reset to 0
    end else if (slowena) begin
        q <= (q == 4'b1001) ? 4'b0000 : q + 1; // increment count or wrap around
    end
end

endmodule