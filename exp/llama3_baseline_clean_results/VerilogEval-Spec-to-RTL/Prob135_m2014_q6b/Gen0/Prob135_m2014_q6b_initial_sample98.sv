module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    reg Y1;
    always @(*) begin
        case (y)
            3'b000: Y1 = w;
            3'b001: Y1 = w;
            3'b010: Y1 = w;
            3'b011: Y1 = 1'b1;
            3'b100: Y1 = w;
            3'b101: Y1 = 1'b1;
            default: Y1 = 1'b0;
        endcase
    end
endmodule