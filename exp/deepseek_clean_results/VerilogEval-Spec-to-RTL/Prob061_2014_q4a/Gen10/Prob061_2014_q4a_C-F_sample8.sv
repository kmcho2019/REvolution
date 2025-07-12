module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg next_Q;

always @(*) begin
    case ({L, E})
        2'b10, 2'b11: next_Q = R;  // Load has highest priority
        2'b01:        next_Q = w;   // Shift when enabled
        default:      next_Q = Q;   // Hold otherwise
    endcase
end

always @(posedge clk) begin
    Q <= next_Q;
end

endmodule