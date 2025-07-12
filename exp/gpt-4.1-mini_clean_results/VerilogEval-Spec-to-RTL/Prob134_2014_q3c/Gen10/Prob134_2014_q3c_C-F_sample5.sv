module TopModule (
    input        clk,       // clock input (not used)
    input        x,
    input  [2:0] y,         // present state
    output reg   Y0,
    output reg   z
);

    // Function to compute next state from present state and input
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
                default: next_state_fn = 3'b000;
            endcase
        end
    endfunction

    wire [2:0] next_state = next_state_fn(y, x);

    // Output z depends combinationally only on present state y
    always @(*) begin
        case (y)
            3'b011, 3'b100: z = 1'b1;
            default:        z = 1'b0;
        endcase
    end

    // Output Y0 is the LSB of next state
    always @(*) begin
        Y0 = next_state[0];
    end

endmodule