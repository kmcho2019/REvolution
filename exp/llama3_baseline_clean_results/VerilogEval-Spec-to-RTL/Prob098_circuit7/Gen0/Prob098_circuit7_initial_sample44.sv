module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a) begin
        q <= ~q; // Invert q when a is 1
    end else begin
        q <= q; // Keep q the same when a is 0
    end
end

endmodule