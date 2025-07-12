module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Function to determine next state based on present state y and input x
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
                default: next_state_fn = 3'b000; // safe default
            endcase
        end
    endfunction

    wire [2:0] next_state;

    assign next_state = next_state_fn(y, x);

    assign z = (y == 3'b011) || (y == 3'b100);

    assign Y0 = next_state[0];

endmodule