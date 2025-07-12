module TopModule(
    input clk,
    input a,
    output reg q = 1'b1 // Initialize q to 1
);

always @(posedge clk) begin
    if (a == 1'b1) begin
        q <= ~q; // Toggle q when a is 1 and clk is rising
    end else begin
        q <= q; // Keep q the same when a is 0
    end
end

endmodule