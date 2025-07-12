module TopModule (
    input        clk,   // clock input (unused)
    input        x,
    input  [2:0] y,
    output reg   Y0,
    output reg   z
);

    reg [2:0] next_state;

    always @(*) begin
        case ({y, x})
            4'b0000: next_state = 3'b000; // y=000, x=0
            4'b0001: next_state = 3'b001; // y=000, x=1
            4'b0010: next_state = 3'b001; // y=001, x=0
            4'b0011: next_state = 3'b100; // y=001, x=1
            4'b0100: next_state = 3'b010; // y=010, x=0
            4'b0101: next_state = 3'b001; // y=010, x=1
            4'b0110: next_state = 3'b001; // y=011, x=0
            4'b0111: next_state = 3'b010; // y=011, x=1
            4'b1000: next_state = 3'b011; // y=100, x=0
            4'b1001: next_state = 3'b100; // y=100, x=1
            default: next_state = 3'b000;
        endcase

        z = (y == 3'b011 || y == 3'b100);
        Y0 = next_state[0];
    end

endmodule