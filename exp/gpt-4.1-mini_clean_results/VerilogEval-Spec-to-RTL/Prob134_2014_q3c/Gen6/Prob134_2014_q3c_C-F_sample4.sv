module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Function: Computes next state from present state y and input x
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

    reg [2:0] next_state;

    // Combinational logic driving next_state register
    always @(*) begin
        next_state = next_state_fn(y, x);
    end

    // Output z is high only for present states 3 (011) and 4 (100)
    // Use bitwise checks to minimize logic depth:
    // 3'b011: y[2]=0, y[1]=1, y[0]=1
    // 3'b100: y[2]=1, y[1]=0, y[0]=0
    // So z = (y == 3'b011) || (y == 3'b100)
    // We write as:
    assign z = ((y == 3'b011) || (y == 3'b100));

    // Y0 is the least significant bit of the next state
    assign Y0 = next_state[0];

endmodule