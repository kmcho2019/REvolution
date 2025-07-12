module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Internal encoded state representation (3 bits)
    wire [2:0] current_state;
    
    // Priority encoder: convert one-hot to binary
    assign current_state = 
        y[0] ? 3'd0 :  // A
        y[1] ? 3'd1 :  // B
        y[2] ? 3'd2 :  // C
        y[3] ? 3'd3 :  // D
        y[4] ? 3'd4 :  // E
        y[5] ? 3'd5 :  // F
        3'd0;         // default to A
    
    // Next state logic
    reg [2:0] next_state;
    always @(*) begin
        case(current_state)
            3'd0: next_state = w ? 3'd0 : 3'd1; // A -> A or B
            3'd1: next_state = w ? 3'd3 : 3'd2; // B -> D or C
            3'd2: next_state = w ? 3'd3 : 3'd4; // C -> D or E
            3'd3: next_state = w ? 3'd0 : 3'd5; // D -> A or F
            3'd4: next_state = w ? 3'd3 : 3'd4; // E -> D or E
            3'd5: next_state = w ? 3'd3 : 3'd2; // F -> D or C
            default: next_state = 3'd0;         // reset to A
        endcase
    end

    // Decoder: convert binary to one-hot (only needed bits)
    assign Y1 = (next_state == 3'd1); // B (y[1])
    assign Y3 = (next_state == 3'd3); // D (y[3])

endmodule