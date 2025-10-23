module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    // y[1] is the output
    assign Y1 = y[1];

    // Next-state logic for y[1]
    // States A and B: y[1] is 0
    // States C, D, E, F: y[1] is 1
    // Transitions to y[1] = 1: 
    // - A (y = 000) to B (y = 001) when w = 1
    // - B (y = 001) to D (y = 010) when w = 1
    // - C (y = 010) to D (y = 011) when w = 1
    // - D (y = 011) to A (y = 000) when w = 1
    // - E (y = 100) to D (y = 011) when w = 1
    // - F (y = 101) to D (y = 011) when w = 1
    // All other transitions result in y[1] = 0
    reg next_y1;
    always @(y, w) begin
        case (y)
            3'b000: next_y1 = w;  // A to B when w = 1
            3'b001: next_y1 = w;  // B to D when w = 1
            3'b010: next_y1 = w;  // C to D when w = 1
            3'b011: next_y1 = w;  // D to A when w = 1
            3'b100: next_y1 = w;  // E to D when w = 1
            3'b101: next_y1 = w;  // F to D when w = 1
            default: next_y1 = 0;  // All other transitions
        endcase
    end

    // Assign next_y1 to y[1] (not needed for this problem)
    // assign y[1] = next_y1;
endmodule