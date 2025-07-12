module TopModule (
    input        clk,   // Clock input (not used in combinational next state logic)
    input        x,
    input  [2:0] y,     // Present state
    output       Y0,
    output       z
);

    // Function to compute next state based on present state y and input x
    function [2:0] get_next_state;
        input [2:0] curr_state;
        input       in_x;
        begin
            case (curr_state)
                3'b000: get_next_state = (in_x == 1'b0) ? 3'b000 : 3'b001;
                3'b001: get_next_state = (in_x == 1'b0) ? 3'b001 : 3'b100;
                3'b010: get_next_state = (in_x == 1'b0) ? 3'b010 : 3'b001;
                3'b011: get_next_state = (in_x == 1'b0) ? 3'b001 : 3'b010;
                3'b100: get_next_state = (in_x == 1'b0) ? 3'b011 : 3'b100;
                default: get_next_state = 3'b000;  // Default fallback to safe state
            endcase
        end
    endfunction

    // Next state wire from function call
    wire [2:0] next_state = get_next_state(y, x);

    // Output Y0 is least significant bit of next state
    assign Y0 = next_state[0];

    // Output z is high only for present states 3 (011) and 4 (100)
    // Using a 5-bit mask with bits set at positions 3 and 4
    localparam [4:0] Z_MASK = 5'b11000;

    // Assign z using masked indexing if present state is valid, else 0
    assign z = (y < 5) ? Z_MASK[y] : 1'b0;

endmodule