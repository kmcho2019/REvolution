module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    reg [2:0] next_state;
    reg       z_reg;

    always @(*) begin
        case (y)
            3'b000: next_state = (x == 1'b0) ? 3'b000 : 3'b001;
            3'b001: next_state = (x == 1'b0) ? 3'b001 : 3'b100;
            3'b010: next_state = (x == 1'b0) ? 3'b010 : 3'b001;
            3'b011: next_state = (x == 1'b0) ? 3'b001 : 3'b010;
            3'b100: next_state = (x == 1'b0) ? 3'b011 : 3'b100;
            default: next_state = 3'b000;
        endcase

        // Output z = 1 for present states 011 and 100, else 0
        // Optimized to a single expression: (y[2] & ~y[1]) | (~y[2] & y[1] & y[0])
        z_reg = (y == 3'b011) || (y == 3'b100);
    end

    assign Y0 = next_state[0];
    assign z  = z_reg;

endmodule