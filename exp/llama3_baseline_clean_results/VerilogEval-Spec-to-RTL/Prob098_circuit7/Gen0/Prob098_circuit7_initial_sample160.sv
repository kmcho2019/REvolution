module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a) begin
        q <= ~q; // Toggle q when a is high
    end else begin
        // Do nothing, keep q unchanged
    end
end

endmodule