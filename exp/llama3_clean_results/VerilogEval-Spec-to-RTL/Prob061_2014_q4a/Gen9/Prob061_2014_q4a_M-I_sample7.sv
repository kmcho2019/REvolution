module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    if (L) begin
        Q <= R;
    end else if (E) begin
        Q <= w;
    end
end

// Alternative implementation considering clock gating and simplified logic
// always @(posedge clk) begin
//     if (~L && ~E) begin
//         // Do nothing, Q remains the same
//     end else if (L) begin
//         Q <= R;
//     end else begin
//         Q <= w;
//     end
// end

endmodule