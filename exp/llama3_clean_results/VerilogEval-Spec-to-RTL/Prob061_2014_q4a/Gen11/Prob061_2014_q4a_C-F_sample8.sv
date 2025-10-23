module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    if (~L && ~E) begin
        // Do nothing, Q remains the same
    end else if (L) begin
        Q <= R;
    end else begin
        Q <= w;
    end
end

// Alternative implementation with a 2:1 multiplexer and clock gating
// wire mux_out;
// assign mux_out = (E)? w : Q;
// always @(posedge clk) begin
//     if (~L && ~E) begin
//         // Do nothing, Q remains the same
//     end else if (L) begin
//         Q <= R;
//     end else begin
//         Q <= mux_out;
//     end
// end

endmodule