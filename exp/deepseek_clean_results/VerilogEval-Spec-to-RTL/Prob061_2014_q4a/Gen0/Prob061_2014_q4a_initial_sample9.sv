module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    case ({E, L})
        2'b10: Q <= w;      // Shift mode
        2'b01: Q <= R;      // Load mode
        default: Q <= Q;    // Hold mode (includes 2'b00 and 2'b11)
    endcase
end

endmodule