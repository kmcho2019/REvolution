module TopModule (
    input clk,
    input a,
    output reg q
);

wire d = ~a;  // Combinational inversion (clear logic separation)

always @(posedge clk) begin
    q <= d;   // Compact sequential assignment
end

endmodule