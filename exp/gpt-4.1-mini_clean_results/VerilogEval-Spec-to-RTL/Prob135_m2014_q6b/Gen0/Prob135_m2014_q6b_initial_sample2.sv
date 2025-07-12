module TopModule (
    input  [2:0] y,    // current state input
    input        w,    // input w
    output       Y1    // output = y[1]
);

    // next_y1 computation based on FSM transitions
    wire next_y1;

    always @(*) begin
        case (y)
            3'b000: next_y1 = 0;           // A
            3'b001: next_y1 = 1;           // B
            3'b010: next_y1 = w ? 1 : 0;  // C
            3'b011: next_y1 = 0;           // D
            3'b100: next_y1 = w ? 1 : 0;  // E
            3'b101: next_y1 = 1;           // F
            default: next_y1 = 0;
        endcase
    end

    assign Y1 = y[1];

endmodule