module TopModule (
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a) begin
        q <= ~q;  // Toggle when a is high
    end
    // Else keep previous value (implicit)
end

endmodule