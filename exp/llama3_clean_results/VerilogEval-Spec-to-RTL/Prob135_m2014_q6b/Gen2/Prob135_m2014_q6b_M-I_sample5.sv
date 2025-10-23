module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output reg Y1;

    // Next state logic for y[1]
    always @(*) begin
        case (y)
            3'b000: Y1 = ~w;
            3'b001: Y1 = ~w;
            3'b010: Y1 = ~w;
            3'b011: Y1 = w;
            3'b100: Y1 = ~w;
            3'b101: Y1 = ~w;
            default: Y1 = 0;
        endcase
    end
endmodule