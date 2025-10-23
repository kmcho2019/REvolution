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
    if (E) begin
        if (L) begin
            q <= R;
        end else begin
            q <= w;
        end
    end
end

assign Q = q;

endmodule