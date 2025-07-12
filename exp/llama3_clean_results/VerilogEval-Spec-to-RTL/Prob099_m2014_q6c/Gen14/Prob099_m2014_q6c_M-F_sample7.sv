module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y2,
    output reg Y3,
    output reg Y4
);

reg [5:0] nextState;

always @(*)
begin
    case (1'b1)
        y[0]: // State A
            begin
                if (!w)
                    nextState = 6'b000010; // Next state is B
                else
                    nextState = 6'b000001; // Next state is A
            end
        y[1]: // State B
            begin
                if (!w)
                    nextState = 6'b000100; // Next state is C
                else
                    nextState = 6'b001000; // Next state is D
            end
        y[2]: // State C
            begin
                if (!w)
                    nextState = 6'b010000; // Next state is E
                else
                    nextState = 6'b001000; // Next state is D
            end
        y[3]: // State D
            begin
                if (!w)
                    nextState = 6'b100000; // Next state is F
                else
                    nextState = 6'b000001; // Next state is A
            end
        y[4]: // State E
            begin
                if (w)
                    nextState = 6'b010000; // Next state is E
                else
                    nextState = 6'b001000; // Next state is D
            end
        y[5]: // State F
            begin
                if (w)
                    nextState = 6'b000100; // Next state is C
                else
                    nextState = 6'b001000; // Next state is D
            end
    endcase

    Y1 = nextState[0];
    Y2 = nextState[1];
    Y3 = nextState[2];
    Y4 = nextState[3];
end

endmodule