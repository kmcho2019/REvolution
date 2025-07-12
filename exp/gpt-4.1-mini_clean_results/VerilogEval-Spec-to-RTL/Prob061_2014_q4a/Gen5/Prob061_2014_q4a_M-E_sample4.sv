module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire d_in;

assign d_in = (L) ? R :
              (E) ? w : Q;

always @(posedge clk) begin
    Q <= d_in;
end

endmodule