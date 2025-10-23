module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    case ({L, E})
        2'b10: Q <= R;    // Load has highest priority
        2'b01: Q <= w;    // Shift when enabled
        default: Q <= Q;  // Explicit hold state (helps power optimization)
    endcase
end

endmodule