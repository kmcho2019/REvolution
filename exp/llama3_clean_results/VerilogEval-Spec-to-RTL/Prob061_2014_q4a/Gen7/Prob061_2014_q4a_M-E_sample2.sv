module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk or posedge L) begin
    if (L) begin
        Q <= R;
    end else if (E) begin
        Q <= w;
    end else begin
        Q <= Q;
    end
end

// Alternative implementation with a 3:1 multiplexer
// wire mux_out;
// assign mux_out = (L) ? R : (E) ? w : Q;
// always @(posedge clk) begin
//     Q <= mux_out;
// end

endmodule