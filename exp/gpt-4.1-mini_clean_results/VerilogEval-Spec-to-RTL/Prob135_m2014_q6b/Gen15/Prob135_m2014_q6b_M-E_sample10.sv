module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    reg next_y1;

    always @(*) begin
        case (y)
            3'b000: next_y1 = 1'b0;            // A(0): next_y1 for next states A or B
            3'b001: next_y1 = w ? 1'b1 : 1'b0; // B(1): next_y1 depends on w (to D or C)
            3'b010: next_y1 = w ? 1'b1 : 1'b0; // C(2): next_y1 depends on w (to D or E)
            3'b011: next_y1 = w ? 1'b0 : 1'b1; // D(3): next_y1 depends on w (to A or F)
            3'b100: next_y1 = 1'b1;            // E(4): next_y1 is 1 regardless (E or D)
            3'b101: next_y1 = 1'b1;            // F(5): next_y1 is 1 regardless (D or C)
            default: next_y1 = 1'b0;           // default fallback
        endcase
    end

    assign Y1 = next_y1;

endmodule