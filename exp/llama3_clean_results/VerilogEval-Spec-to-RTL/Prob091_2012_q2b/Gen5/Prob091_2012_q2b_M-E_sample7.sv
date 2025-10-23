module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    reg [5:0] nextState;

    always @(*) begin
        case (1'b1)
            y[0]: nextState = w ? 6'b000010 : 6'b000001; // State A
            y[1]: nextState = w ? 6'b000100 : 6'b001000; // State B
            y[2]: nextState = w ? 6'b010000 : 6'b001000; // State C
            y[3]: nextState = w ? 6'b100000 : 6'b000001; // State D
            y[4]: nextState = w ? 6'b010000 : 6'b001000; // State E
            y[5]: nextState = w ? 6'b000100 : 6'b001000; // State F
        endcase
    end

    assign Y1 = nextState[1];
    assign Y3 = nextState[3];

endmodule