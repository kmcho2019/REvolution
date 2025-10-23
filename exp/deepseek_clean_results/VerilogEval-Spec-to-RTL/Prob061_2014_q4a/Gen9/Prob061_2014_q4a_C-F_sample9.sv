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
        2'b1?: Q <= R;    // Highest priority: Load
        2'b01: Q <= w;    // Shift when enabled
        default: Q <= Q;  // Hold state otherwise
    endcase
end

endmodule