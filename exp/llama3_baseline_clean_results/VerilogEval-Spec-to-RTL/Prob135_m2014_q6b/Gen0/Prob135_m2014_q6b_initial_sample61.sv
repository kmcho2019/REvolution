module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    reg Y1_next;

    always @(y, w) begin
        case (y)
            3'b000: // State A
                Y1_next = w ? 0 : 0;
            3'b001: // State B
                Y1_next = w ? 1 : 0;
            3'b010: // State C
                Y1_next = w ? 1 : 0;
            3'b011: // State D
                Y1_next = w ? 0 : 1;
            3'b100: // State E
                Y1_next = w ? 1 : 1;
            3'b101: // State F
                Y1_next = w ? 1 : 0;
            default:
                Y1_next = 0;
        endcase
    end

    assign Y1 = y[1];

endmodule