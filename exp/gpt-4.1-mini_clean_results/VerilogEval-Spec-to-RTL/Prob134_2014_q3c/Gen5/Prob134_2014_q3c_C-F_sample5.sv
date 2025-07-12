module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    reg [2:0] next_state;

    // Function to compute next state from present state y and input x
    function [2:0] compute_next_state;
        input [2:0] state;
        input       in_x;
        begin
            case (state)
                3'b000: compute_next_state = (in_x == 1'b0) ? 3'b000 : 3'b001;
                3'b001: compute_next_state = (in_x == 1'b0) ? 3'b001 : 3'b100;
                3'b010: compute_next_state = (in_x == 1'b0) ? 3'b010 : 3'b001;
                3'b011: compute_next_state = (in_x == 1'b0) ? 3'b001 : 3'b010;
                3'b100: compute_next_state = (in_x == 1'b0) ? 3'b011 : 3'b100;
                default: compute_next_state = 3'b000; // safe default for unused states
            endcase
        end
    endfunction

    // Combinational always block to assign next_state using the function
    always @(*) begin
        next_state = compute_next_state(y, x);
    end

    // Output Y0 is LSB of next state
    assign Y0 = next_state[0];

    // Output z depends combinationally on present state y
    assign z = (y == 3'b011) || (y == 3'b100);

endmodule