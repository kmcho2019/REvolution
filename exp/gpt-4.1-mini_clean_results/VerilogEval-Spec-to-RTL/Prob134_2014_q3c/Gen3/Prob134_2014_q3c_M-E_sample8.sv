module TopModule (
    input        clk,  // clk unused as module is combinational
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Function to compute next state
    function [2:0] next_state_func;
        input [2:0] y_in;
        input       x_in;
        begin
            next_state_func = 
                (y_in == 3'b000) ? (x_in ? 3'b001 : 3'b000) :
                (y_in == 3'b001) ? (x_in ? 3'b100 : 3'b001) :
                (y_in == 3'b010) ? (x_in ? 3'b001 : 3'b010) :
                (y_in == 3'b011) ? (x_in ? 3'b010 : 3'b001) :
                (y_in == 3'b100) ? (x_in ? 3'b100 : 3'b011) :
                3'b000; // Default
        end
    endfunction

    // Function to compute output z
    function z_func;
        input [2:0] y_in;
        begin
            z_func = (y_in == 3'b011) || (y_in == 3'b100);
        end
    endfunction

    wire [2:0] next_state = next_state_func(y, x);

    assign Y0 = next_state[0];
    assign z  = z_func(y);

endmodule