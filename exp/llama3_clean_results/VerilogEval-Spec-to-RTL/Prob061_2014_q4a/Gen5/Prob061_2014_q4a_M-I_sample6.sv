module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

reg q;
reg clk_en; // Clock enable signal

// Generate clock enable signal
assign clk_en = L | E;

always @(posedge clk) begin
    if (clk_en) begin
        if (L) begin
            q <= R;
        end else if (E) begin
            q <= w;
        end
    end
end

assign Q = q;

endmodule