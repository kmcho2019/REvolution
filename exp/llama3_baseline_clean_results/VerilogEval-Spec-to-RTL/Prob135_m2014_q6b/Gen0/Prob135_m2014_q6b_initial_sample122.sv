module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    reg Y1_next;
    assign Y1 = y[1];

    always @(y or w) begin
        case (y)
            3'b000: // A
                Y1_next = w;
            3'b001: // B
                Y1_next = 1'b0;
            3'b010: // C
                Y1_next = ~w;
            3'b011: // D
                Y1_next = 1'b1;
            3'b100: // E
                Y1_next = w;
            3'b101: // F
                Y1_next = ~w;
            default:
                Y1_next = 1'bx;
        endcase
    end

    assign Y1 = y[1];

endmodule