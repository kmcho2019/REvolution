module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    reg [5:0] nextState;

    always @(*) begin
        case (1'b1)
            y[0]: begin // State A
                if (~w) nextState = 6'b000010; // Next state is B
                else nextState = 6'b000001; // Next state is A
            end
            y[1]: begin // State B
                if (~w) nextState = 6'b000100; // Next state is C
                else nextState = 6'b001000; // Next state is D
            end
            y[2]: begin // State C
                if (~w) nextState = 6'b010000; // Next state is E
                else nextState = 6'b001000; // Next state is D
            end
            y[3]: begin // State D
                if (~w) nextState = 6'b100000; // Next state is F
                else nextState = 6'b000001; // Next state is A
            end
            y[4]: begin // State E
                if (w) nextState = 6'b010000; // Next state is E
                else nextState = 6'b001000; // Next state is D
            end
            y[5]: begin // State F
                if (w) nextState = 6'b000100; // Next state is C
                else nextState = 6'b001000; // Next state is D
            end
            default: nextState = 6'b000001; // Default next state is A
        endcase
    end

    assign Y1 = nextState[0];
    assign Y3 = nextState[3];

endmodule