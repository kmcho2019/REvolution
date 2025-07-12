module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    reg [2:0] next_state;
    reg       z_reg;

    // Function to compute next state based on current state and input x
    function [2:0] f_next_state;
        input [2:0] state;
        input       in_x;
        begin
            case (state)
                3'b000: f_next_state = in_x ? 3'b001 : 3'b000;
                3'b001: f_next_state = in_x ? 3'b100 : 3'b001;
                3'b010: f_next_state = in_x ? 3'b001 : 3'b010;
                3'b011: f_next_state = in_x ? 3'b010 : 3'b001;
                3'b100: f_next_state = in_x ? 3'b100 : 3'b011;
                default: f_next_state = 3'b000;
            endcase
        end
    endfunction

    // Function to compute output z based on current state input y
    function f_z_out;
        input [2:0] state;
        begin
            case (state)
                3'b011,
                3'b100: f_z_out = 1'b1;
                default: f_z_out = 1'b0;
            endcase
        end
    endfunction

    always @(*) begin
        next_state = f_next_state(y, x);
        z_reg = f_z_out(y);
    end

    assign Y0 = next_state[0];
    assign z = z_reg;

endmodule