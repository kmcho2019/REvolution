module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    reg [2:0] nextState;

    always @(*) begin
        case (y)
            3'b000: nextState[1] = w; // A
            3'b001: nextState[1] = ~w; // B
            3'b010: nextState[1] = ~w; // C
            3'b011: nextState[1] = 1'b1; // D
            3'b100: nextState[1] = ~w; // E
            3'b101: nextState[1] = w; // F
            default: nextState[1] = 1'b0;
        endcase
    end

    assign Y1 = nextState[1];

endmodule