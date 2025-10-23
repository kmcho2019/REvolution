module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a) begin
        q <= ~q; // Toggle q when a is high
    end else begin
        q <= q; // Maintain current state when a is low
    end
end

endmodule