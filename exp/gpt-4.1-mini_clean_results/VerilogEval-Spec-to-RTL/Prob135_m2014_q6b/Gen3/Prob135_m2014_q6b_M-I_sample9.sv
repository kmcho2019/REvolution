module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    reg y1_next;

    // Next-state logic for y[1] derived from FSM transitions:
    // States: A=000, B=001, C=010, D=011, E=100, F=101
    // Based on the FSM, derive minimized logic for y1_next:

    always @(*) begin
        case (y)
            3'b000: y1_next = 1'b0;                 // A
            3'b001: y1_next = 1'b1;                 // B
            3'b010: y1_next = w ? 1'b1 : 1'b0;     // C
            3'b011: y1_next = 1'b0;                 // D
            3'b100: y1_next = w ? 1'b1 : 1'b0;     // E
            3'b101: y1_next = 1'b1;                 // F
            default: y1_next = 1'b0;                // Unused states default to 0
        endcase
    end

    assign Y1 = y1_next;

endmodule