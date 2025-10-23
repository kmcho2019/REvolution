module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // State transition matrix [present_state][x] -> next_state
    // Format: {next_state_x0, next_state_x1}
    parameter [2:0] STATE_TABLE [0:4][0:1] = '{
        '{3'b000, 3'b001},  // State 0
        '{3'b001, 3'b100},  // State 1
        '{3'b010, 3'b001},  // State 2
        '{3'b001, 3'b010},  // State 3
        '{3'b011, 3'b100}   // State 4
    };

    // Next state lookup
    wire [2:0] next_state = STATE_TABLE[y][x];

    // Output assignments
    assign Y0 = next_state[0];
    assign z = (y == 3'b011) | (y == 3'b100);  // z=1 only in states 3 and 4

endmodule