module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire next_Q;
wire clk_en;

// Smart clock gating - only enable when value will change
assign clk_en = (L && (R != Q)) || (E && !L && (w != Q));

// Priority mux: Load > Shift > Hold
assign next_Q = L ? R : 
                E ? w : Q;

// Sequential element with optimized clock gating
always @(posedge clk) begin
    if (clk_en) begin
        Q <= next_Q;
    end
end

endmodule