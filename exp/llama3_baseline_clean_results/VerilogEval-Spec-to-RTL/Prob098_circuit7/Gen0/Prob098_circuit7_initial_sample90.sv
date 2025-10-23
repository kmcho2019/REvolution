module TopModule (
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a) begin
        q <= ~q; // Toggle q when a is 1 at the rising edge of clk
    end else begin
        // Do nothing, keep q the same when a is 0 at the rising edge of clk
    end
end

endmodule