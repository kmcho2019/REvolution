module TopModule(
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

always_ff @(posedge clk) begin
    Q <= (L) ? R : ((E) ? w : Q);
end

endmodule