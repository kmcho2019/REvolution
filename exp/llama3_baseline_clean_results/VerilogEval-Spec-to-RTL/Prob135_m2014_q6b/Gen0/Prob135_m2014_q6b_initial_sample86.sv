module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    assign Y1 = y[1];

    // Next state logic for y[1]
    wire y1_next;
    always @(*)
    begin
        case (y)
            3'b000: // A
                y1_next = w;
            3'b001: // B
                y1_next = ~w;
            3'b010: // C
                y1_next = ~w;
            3'b011: // D
                y1_next = ~w;
            3'b100: // E
                y1_next = ~w;
            3'b101: // F
                y1_next = ~w;
            default:
                y1_next = 1'bx;
        endcase
    end

    // D flip-flop for y[1]
    reg y1_reg;
    always @(posedge w or negedge w)
    begin
        y1_reg <= y1_next;
    end

    assign Y1 = y1_reg;
endmodule