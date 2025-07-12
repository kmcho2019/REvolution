module TopModule (
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    q <= ~a;  // Direct inversion and sequential update
end

endmodule