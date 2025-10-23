module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state computation (bit-sliced)
    wire next_Y0 = (x & (~y[2] & ~y[1])) |  // State 000 with x=1
                  (~x & y[0]) |            // States 001/011 with x=0
                  (x & y[1] & ~y[0]);      // State 010 with x=1

    wire next_Y1 = (~x & y[2] & ~y[0]);    // State 100 with x=0

    wire next_Y2 = (x & ~y[2] & y[0]);     // State 001 with x=1

    // Combine next state bits
    wire [2:0] next_state = {next_Y2, next_Y1, next_Y0};

    // Output assignments
    assign Y0 = next_state[0];
    assign z = (y == 3'b011) | (y == 3'b100);

endmodule