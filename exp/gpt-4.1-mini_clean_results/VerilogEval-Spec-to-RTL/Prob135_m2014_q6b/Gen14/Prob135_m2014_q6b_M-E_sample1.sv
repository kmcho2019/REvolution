module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);
    reg y1_next;

    always @(*) begin
        case (y)
            3'b000: y1_next = 1'b0;              // A: next y1 = 0
            3'b001: y1_next = 1'b1;              // B: next y1 = 1
            3'b010: y1_next = w ? 1'b1 : 1'b0;  // C: next y1 depends on w
            3'b011: y1_next = 1'b0;              // D: next y1 = 0
            3'b100: y1_next = w ? 1'b1 : 1'b0;  // E: next y1 depends on w
            3'b101: y1_next = 1'b1;              // F: next y1 = 1
            default: y1_next = 1'b0;
        endcase
    end

    assign Y1 = y[1];

endmodule