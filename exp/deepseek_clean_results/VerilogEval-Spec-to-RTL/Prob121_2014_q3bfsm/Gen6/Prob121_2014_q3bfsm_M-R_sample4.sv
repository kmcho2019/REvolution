module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // State encoding with one-hot parameters for clarity
    reg [2:0] state;
    parameter [2:0] S0 = 3'b000,
                    S1 = 3'b001,
                    S2 = 3'b010,
                    S3 = 3'b011,
                    S4 = 3'b100;

    // Next state logic using continuous assignments
    wire [2:0] next_state;
    assign next_state[0] = (~state[2] & ~state[1] & x) |  // S0 -> S1 when x=1
                          (state[1] & ~state[0] & ~x) |   // S2 -> S1 when x=0
                          (state[2] & ~state[1] & ~x);    // S4 -> S3 (bit 0 set)

    assign next_state[1] = (~state[2] & state[0] & x) |   // S1 -> S4 when x=1
                          (state[1] & ~state[0] & x) |    // S2 -> S1 when x=1
                          (state[2] & state[1] & x);      // S3 -> S2 when x=1

    assign next_state[2] = (~state[2] & state[1] & state[0] & x) |  // S3 -> S2 when x=1
                          (state[2] & x);                           // S4 -> S4 when x=1

    // Output logic - z is high when in S3 or S4
    assign z = state[2] | (state[1] & state[0]);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

endmodule