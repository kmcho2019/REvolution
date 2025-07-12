module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    reg [2:0] state;
    wire [2:0] next_state;

    // Next state logic using continuous assignments
    assign next_state[0] = (~state[2] & ~state[1] & state[0] & ~x) |  // 001 -> 001 (x=0)
                          (~state[2] & state[1] & ~state[0] & ~x) |   // 010 -> 010 (x=0)
                          (~state[2] & state[1] & state[0] & ~x) |    // 011 -> 001 (x=0)
                          (state[2] & ~state[1] & ~state[0] & x) |    // 100 -> 100 (x=1)
                          (~state[2] & ~state[1] & ~state[0] & x);    // 000 -> 001 (x=1)

    assign next_state[1] = (~state[2] & state[1] & ~state[0] & ~x) |   // 010 -> 010 (x=0)
                          (~state[2] & state[1] & state[0] & x) |     // 011 -> 010 (x=1)
                          (state[2] & ~state[1] & ~state[0] & ~x);     // 100 -> 011 (x=0)

    assign next_state[2] = (~state[2] & ~state[1] & state[0] & x) |    // 001 -> 100 (x=1)
                          (state[2] & ~state[1] & ~state[0]);          // 100 stays or 011->?

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;
        else
            state <= next_state;
    end

    // Output logic remains the same
    assign z = (state == 3'b011) | (state == 3'b100);

endmodule