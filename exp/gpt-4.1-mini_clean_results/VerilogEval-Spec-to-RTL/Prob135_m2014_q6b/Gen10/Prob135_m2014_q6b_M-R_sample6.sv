module TopModule(
    input  [2:0] y,
    input        w,
    output reg   Y1
);

    always @(*) begin
        case (y)
            3'b000: Y1 = 1'b0;              // A -> A or B (both y1=0)
            3'b001: Y1 = 1'b1;              // B -> C or D (both y1=1)
            3'b010: Y1 = w ? 1'b1 : 1'b0;  // C -> D(y1=1) if w=1 else E(y1=0)
            3'b011: Y1 = 1'b0;              // D -> A or F (both y1=0)
            3'b100: Y1 = w ? 1'b1 : 1'b0;  // E -> D(y1=1) if w=1 else E(y1=0)
            3'b101: Y1 = 1'b1;              // F -> D or C (both y1=1)
            default: Y1 = 1'b0;             // Default safe state
        endcase
    end

endmodule