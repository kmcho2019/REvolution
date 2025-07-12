module TopModule (
    input [5:0] y,  // One-hot encoded state
    input w,        // State machine input
    output Y1,      // Next state for y[1] (state B)
    output Y3       // Next state for y[3] (state D)
);

    // State decoder converts one-hot to binary
    wire [2:0] current_state;
    StateDecoder decoder(
        .y(y),
        .state(current_state)
    );

    // Transition logic computes next state
    wire [2:0] next_state;
    TransitionLogic trans(
        .current_state(current_state),
        .w(w),
        .next_state(next_state)
    );

    // State encoder generates required outputs
    StateEncoder encoder(
        .next_state(next_state),
        .Y1(Y1),
        .Y3(Y3)
    );

endmodule

module StateDecoder (
    input [5:0] y,
    output reg [2:0] state
);
    always @(*) begin
        case (y)
            6'b000001: state = 3'b000; // A
            6'b000010: state = 3'b001; // B
            6'b000100: state = 3'b010; // C
            6'b001000: state = 3'b011; // D
            6'b010000: state = 3'b100; // E
            6'b100000: state = 3'b101; // F
            default:   state = 3'b000; // Default to A
        endcase
    end
endmodule

module TransitionLogic (
    input [2:0] current_state,
    input w,
    output reg [2:0] next_state
);
    always @(*) begin
        case (current_state)
            3'b000: next_state = w ? 3'b001 : 3'b000; // A -> B or A
            3'b001: next_state = w ? 3'b010 : 3'b011; // B -> C or D
            3'b010: next_state = w ? 3'b100 : 3'b011; // C -> E or D
            3'b011: next_state = w ? 3'b101 : 3'b000; // D -> F or A
            3'b100: next_state = w ? 3'b100 : 3'b011; // E -> E or D
            3'b101: next_state = w ? 3'b010 : 3'b011; // F -> C or D
            default: next_state = 3'b000;              // Default to A
        endcase
    end
endmodule

module StateEncoder (
    input [2:0] next_state,
    output Y1,
    output Y3
);
    // Y1 is set when next state is B (001)
    assign Y1 = (next_state == 3'b001);
    
    // Y3 is set when next state is D (011)
    assign Y3 = (next_state == 3'b011);
endmodule