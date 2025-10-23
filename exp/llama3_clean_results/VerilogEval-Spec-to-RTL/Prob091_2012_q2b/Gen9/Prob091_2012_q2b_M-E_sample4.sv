module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    reg [5:0] nextState;

    always @(*) begin
        case ({y, w})
            6'b000001_1: nextState = 6'b000010; // A (0) --1--> B
            6'b000001_0: nextState = 6'b000001; // A (0) --0--> A
            6'b000010_1: nextState = 6'b000100; // B (0) --1--> C
            6'b000010_0: nextState = 6'b001000; // B (0) --0--> D
            6'b000100_1: nextState = 6'b010000; // C (0) --1--> E
            6'b000100_0: nextState = 6'b001000; // C (0) --0--> D
            6'b001000_1: nextState = 6'b100000; // D (0) --1--> F
            6'b001000_0: nextState = 6'b000001; // D (0) --0--> A
            6'b010000_1: nextState = 6'b010000; // E (1) --1--> E
            6'b010000_0: nextState = 6'b001000; // E (1) --0--> D
            6'b100000_1: nextState = 6'b000100; // F (1) --1--> C
            6'b100000_0: nextState = 6'b001000; // F (1) --0--> D
            default: nextState = 6'b000001; // Default to state A
        endcase
    end

    assign Y1 = nextState[1]; // Output Y1 is the value of nextState[1]
    assign Y3 = nextState[3]; // Output Y3 is the value of nextState[3]

endmodule