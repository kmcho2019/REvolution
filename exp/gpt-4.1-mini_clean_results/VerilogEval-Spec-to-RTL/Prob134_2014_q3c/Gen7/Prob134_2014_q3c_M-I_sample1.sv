module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    reg [2:0] next_state;
    reg       Y0_reg;

    always @(*) begin
        case (y)
            3'b000: next_state = (x == 1'b0) ? 3'b000 : 3'b001;
            3'b001: next_state = (x == 1'b0) ? 3'b001 : 3'b100;
            3'b010: next_state = (x == 1'b0) ? 3'b010 : 3'b001;
            3'b011: next_state = (x == 1'b0) ? 3'b001 : 3'b010;
            3'b100: next_state = (x == 1'b0) ? 3'b011 : 3'b100;
            default: next_state = 3'b000;
        endcase
        Y0_reg = next_state[0];
    end

    // Output z = 1 if y == 3'b011 or 3'b100, else 0
    // Use a simple comparison on y[2:1] bits as 2'b01 covers both 011 and 100 is 4 decimal = 100 bin
    // Since states are sparse, simplest and minimal logic is direct equality:
    assign z = (y == 3'b011) || (y == 3'b100);

    assign Y0 = Y0_reg;

endmodule