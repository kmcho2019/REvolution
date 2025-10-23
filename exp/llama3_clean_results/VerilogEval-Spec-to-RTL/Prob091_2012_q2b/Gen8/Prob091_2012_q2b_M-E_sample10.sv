module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    // Define the LUT for next state logic
    reg [5:0] nextState;
    always @(y or w) begin
        case ({y, w})
            // A (000001) transitions
            6'b000001_0: nextState = 6'b000001; // A -> A
            6'b000001_1: nextState = 6'b000010; // A -> B
            // B (000010) transitions
            6'b000010_0: nextState = 6'b001000; // B -> D
            6'b000010_1: nextState = 6'b000100; // B -> C
            // C (000100) transitions
            6'b000100_0: nextState = 6'b001000; // C -> D
            6'b000100_1: nextState = 6'b010000; // C -> E
            // D (001000) transitions
            6'b001000_0: nextState = 6'b000001; // D -> A
            6'b001000_1: nextState = 6'b100000; // D -> F
            // E (010000) transitions
            6'b010000_0: nextState = 6'b001000; // E -> D
            6'b010000_1: nextState = 6'b010000; // E -> E
            // F (100000) transitions
            6'b100000_0: nextState = 6'b001000; // F -> D
            6'b100000_1: nextState = 6'b000100; // F -> C
            default: nextState = 6'b000001; // Default to state A
        endcase
    end

    // Extract Y1 and Y3 from the next state
    assign Y1 = nextState[1];
    assign Y3 = nextState[3];

endmodule