module TopModule(
    input  [2:0] y,
    input        w,
    output reg   Y1
);

    reg y1_next;

    always @(*) begin
        case (y)
            3'b000: y1_next = 1'b0;               // A
            3'b001: y1_next = 1'b1;               // B
            3'b010: y1_next = w ? 1'b1 : 1'b0;   // C
            3'b011: y1_next = 1'b0;               // D
            3'b100: y1_next = w ? 1'b1 : 1'b0;   // E
            3'b101: y1_next = 1'b1;               // F
            default: y1_next = 1'b0;              // undefined states default to 0
        endcase
    end

    always @(*) begin
        Y1 = y1_next;
    end

endmodule