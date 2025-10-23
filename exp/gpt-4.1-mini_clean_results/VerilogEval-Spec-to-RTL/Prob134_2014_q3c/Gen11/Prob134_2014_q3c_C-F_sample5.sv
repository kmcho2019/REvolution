module TopModule (
    input        clk,   // clock input (not used here)
    input        x,
    input  [2:0] y,     // present state
    output       Y0,
    output       z
);

    reg [2:0] next_state;
    reg       z_reg;

    // Function to compute output z based on present state y
    function automatic f_z_out;
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
        // Compute next state based on present state and input x
        case (y)
            3'b000: next_state = (x == 1'b0) ? 3'b000 : 3'b001;
            3'b001: next_state = (x == 1'b0) ? 3'b001 : 3'b100;
            3'b010: next_state = (x == 1'b0) ? 3'b010 : 3'b001;
            3'b011: next_state = (x == 1'b0) ? 3'b001 : 3'b010;
            3'b100: next_state = (x == 1'b0) ? 3'b011 : 3'b100;
            default: next_state = 3'b000;
        endcase

        // Compute output z from present state y
        z_reg = f_z_out(y);
    end

    assign Y0 = next_state[0];
    assign z = z_reg;

endmodule