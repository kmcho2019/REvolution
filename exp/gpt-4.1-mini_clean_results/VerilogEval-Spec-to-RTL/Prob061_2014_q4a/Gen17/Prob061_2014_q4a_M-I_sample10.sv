module TopModule (
    input  clk,
    input  w,
    input  R,
    input  E,
    input  L,
    output reg Q
);

    // Control vector encoding:
    // 2'b10 = load (L asserted)
    // 2'b01 = shift (E asserted, L deasserted)
    // 2'b00 = hold
    wire [1:0] ctrl = {L, E & ~L};

    always @(posedge clk) begin
        case (ctrl)
            2'b10: Q <= R;   // Load has highest priority
            2'b01: Q <= w;   // Shift on enable
            default: /* hold Q */;
        endcase
    end

endmodule