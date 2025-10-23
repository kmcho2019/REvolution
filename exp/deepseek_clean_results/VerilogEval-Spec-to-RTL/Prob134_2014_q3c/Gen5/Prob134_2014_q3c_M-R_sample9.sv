module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    wire [2:0] next_state;

    // Next state logic using direct assignments
    assign next_state[0] = (~x & (y == 3'b000)) |  // 000 -> 000 (bit 0)
                          (~x & (y == 3'b001)) |  // 001 -> 001
                          (~x & (y == 3'b010)) |  // 010 -> 010
                          (~x & (y == 3'b011)) |  // 011 -> 001
                          (x & (y == 3'b000)) |   // 000 -> 001
                          (x & (y == 3'b010)) |   // 010 -> 001
                          (x & (y == 3'b011));    // 011 -> 010 (bit 0)

    assign next_state[1] = (~x & (y == 3'b010)) |  // 010 -> 010 (bit 1)
                          (x & (y == 3'b011)) |    // 011 -> 010
                          (~x & (y == 3'b100));    // 100 -> 011

    assign next_state[2] = (x & (y == 3'b001)) |   // 001 -> 100
                          (x & (y == 3'b100)) |    // 100 -> 100
                          (~x & (y == 3'b100));    // 100 -> 011

    // Output logic remains the same
    assign Y0 = next_state[0];
    assign z = (y == 3'b011) | (y == 3'b100);

endmodule