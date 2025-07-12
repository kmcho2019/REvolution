module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

reg q;

always @(posedge clk) begin
    q <= L ? R : (E ? w : q);
end

assign Q = q;

endmodule