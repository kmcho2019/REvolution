module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    wire [2:0] Y;

    // combinational function to determine next state
    function [2:0] next_state;
        input [2:0] curr_state;
        input x_in;
        begin
            case (curr_state)
                3'b000: next_state = (x_in == 1'b0) ? 3'b000 : 3'b001;
                3'b001: next_state = (x_in == 1'b0) ? 3'b001 : 3'b100;
                3'b010: next_state = (x_in == 1'b0) ? 3'b010 : 3'b001;
                3'b011: next_state = (x_in == 1'b0) ? 3'b001 : 3'b010;
                3'b100: next_state = (x_in == 1'b0) ? 3'b011 : 3'b100;
                default: next_state = 3'b000;
            endcase
        end
    endfunction

    assign Y = next_state(y, x);
    assign Y0 = Y[0];

    // output z depends on current state y
    assign z = (y == 3'b011) || (y == 3'b100);

endmodule