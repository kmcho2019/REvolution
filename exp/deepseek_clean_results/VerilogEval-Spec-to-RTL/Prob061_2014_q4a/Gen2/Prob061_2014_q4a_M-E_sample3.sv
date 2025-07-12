module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

reg state;

// Combinational output
assign Q = state;

// Sequential state update
always @(posedge clk) begin
    case ({L, E})
        2'b10: state <= R;    // Load has priority
        2'b01: state <= w;    // Shift when enabled
        default: state <= state; // Explicit state retention
    endcase
end

endmodule