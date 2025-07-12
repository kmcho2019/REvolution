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
    if (L) begin
        q <= R;
    end else if (E) begin
        q <= w;
    end else begin
        q <= q; // Retain the current state when neither L nor E is asserted
    end
end

assign Q = q;

endmodule