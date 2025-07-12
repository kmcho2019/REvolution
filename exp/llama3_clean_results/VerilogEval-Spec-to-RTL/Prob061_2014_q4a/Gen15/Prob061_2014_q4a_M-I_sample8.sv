module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg clk_enable;

always @(posedge clk) begin
    if (L) begin
        Q <= R;
    end else if (E && (w!== Q)) begin
        Q <= w;
    end
end

assign clk_enable = L || (E && (w!== Q));

// Clock gating
// always @(posedge clk) begin
//     if (clk_enable) begin
//         if (L) begin
//             Q <= R;
//         end else if (E) begin
//             Q <= w;
//         end
//     end
// end

endmodule