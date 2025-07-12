module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Function to compute next state based on present state y and input x
    function [2:0] next_state_fn;
        input [2:0] y_in;
        input       x_in;
        begin
            case (y_in)
                3'b000: next_state_fn = (x_in == 1'b0) ? 3'b000 : 3'b001;
                3'b001: next_state_fn = (x_in == 1'b0) ? 3'b001 : 3'b100;
                3'b010: next_state_fn = (x_in == 1'b0) ? 3'b010 : 3'b001;
                3'b011: next_state_fn = (x_in == 1'b0) ? 3'b001 : 3'b010;
                3'b100: next_state_fn = (x_in == 1'b0) ? 3'b011 : 3'b100;
                default: next_state_fn = 3'b000; // safe default state
            endcase
        end
    endfunction

    wire [2:0] next_state;

    // Compute next state combinationally
    assign next_state = next_state_fn(y, x);

    // Output Y0 is the LSB of the next state
    assign Y0 = next_state[0];

    // Output z depends combinationally only on present state y
    assign z = (y == 3'b011) || (y == 3'b100);

endmodule