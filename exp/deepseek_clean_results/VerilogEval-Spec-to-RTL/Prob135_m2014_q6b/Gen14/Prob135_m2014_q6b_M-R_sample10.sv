module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Refactored next-state logic for y[1]
    wire next_y1;
    assign next_y1 = (y == 3'b000) ? (w ? 1'b0 : 1'b0) :  // A: stays 0 or ->B (0)
                    (y == 3'b001) ? (w ? 1'b1 : 1'b0) :  // B: ->D (1) or ->C (0)
                    (y == 3'b010) ? (w ? 1'b1 : 1'b1) :  // C: ->D (1) or ->E (1)
                    (y == 3'b011) ? (w ? 1'b0 : 1'b0) :  // D: ->A (0) or ->F (0)
                    (y == 3'b100) ? (w ? 1'b1 : 1'b1) :  // E: ->D (1) or stays (1)
                    (y == 3'b101) ? (w ? 1'b1 : 1'b0) :  // F: ->D (1) or ->C (0)
                    1'b0;  // Default case (shouldn't occur)

endmodule