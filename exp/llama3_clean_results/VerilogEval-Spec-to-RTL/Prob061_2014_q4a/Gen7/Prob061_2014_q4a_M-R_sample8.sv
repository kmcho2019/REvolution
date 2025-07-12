module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg data_in;

assign data_in = (L) ? R : (E) ? w : Q;

always @(posedge clk) begin
    Q <= data_in;
end

endmodule