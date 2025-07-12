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
            2'b10: Q <= w;    // Shift mode
            2'b01: Q <= R;    // Load mode
            2'b11: Q <= R;    // Load has priority over shift
            default: Q <= Q;   // Hold current value
        endcase
    end

endmodule