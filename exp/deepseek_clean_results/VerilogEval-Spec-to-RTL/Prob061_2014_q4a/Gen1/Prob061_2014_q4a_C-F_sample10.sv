module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    casex ({L, E})
        2'b1?: Q <= R;  // Load has highest priority
        2'b01: Q <= w;   // Shift when enabled
        default: Q <= Q; // Explicit maintain state (helps with clock gating)
    endcase
end

endmodule