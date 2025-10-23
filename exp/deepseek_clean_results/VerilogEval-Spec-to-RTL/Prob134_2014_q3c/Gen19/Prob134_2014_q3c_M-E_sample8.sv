module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // State transition matrix [current_state][x] -> next_state
    wire [2:0] next_state_matrix [0:4][0:1] = '{
        '{3'b000, 3'b001},  // State 000
        '{3'b001, 3'b100},  // State 001
        '{3'b010, 3'b001},  // State 010
        '{3'b001, 3'b010},  // State 011
        '{3'b011, 3'b100}   // State 100
    };

    // Current state index decoder
    wire is_state_000 = (y == 3'b000);
    wire is_state_001 = (y == 3'b001);
    wire is_state_010 = (y == 3'b010);
    wire is_state_011 = (y == 3'b011);
    wire is_state_100 = (y == 3'b100);

    // Next state selection
    wire [2:0] next_state = 
        (is_state_000 ? next_state_matrix[0][x] :
         is_state_001 ? next_state_matrix[1][x] :
         is_state_010 ? next_state_matrix[2][x] :
         is_state_011 ? next_state_matrix[3][x] :
                         next_state_matrix[4][x]);

    // Output assignments
    assign Y0 = next_state[0];
    assign z = is_state_011 | is_state_100;

endmodule