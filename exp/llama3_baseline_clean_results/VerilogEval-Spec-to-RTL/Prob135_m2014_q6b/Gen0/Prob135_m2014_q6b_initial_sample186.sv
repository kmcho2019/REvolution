module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    reg Y1;

    always @(*)
    begin
        case(y)
            3'b000: // A
                Y1 = w ? 0 : 0;
            3'b001: // B
                Y1 = w ? 0 : 0;
            3'b010: // C
                Y1 = 1;
            3'b011: // D
                Y1 = 1;
            3'b100: // E
                Y1 = 1;
            3'b101: // F
                Y1 = 1;
            default: 
                Y1 = 0;
        endcase
    end
endmodule