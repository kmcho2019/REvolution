module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // Define state parameters
    parameter S0 = 3'b000,
              S1 = 3'b001,
              S2 = 3'b010,
              S3 = 3'b011,
              S4 = 3'b100;

    // State register
    reg [2:0] state;

    // Next state logic broken down by bits
    wire [2:0] next_state;
    assign next_state[0] = (~state[2] & ~state[1] & state[0] & ~x) |  // S1 when x=0
                          (~state[2] & state[1] & ~state[0] & x) |    // S2 when x=1
                          (~state[2] & state[1] & state[0] & ~x) |    // S3 when x=0
                          (state[2] & ~state[1] & ~state[0] & ~x);    // S4 when x=0

    assign next_state[1] = (~state[2] & ~state[1] & state[0] & x) |   // S1 when x=1
                          (~state[2] & state[1] & ~state[0] & ~x) |   // S2 when x=0
                          (~state[2] & state[1] & state[0] & x) |     // S3 when x=1
                          (state[2] & ~state[1] & ~state[0] & ~x);   // S4 when x=0

    assign next_state[2] = (~state[2] & ~state[1] & state[0] & x) |   // S1 when x=1
                          (state[2] & ~state[1] & ~state[0] & x);     // S4 when x=1

    // Sequential logic with output
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 1'b0;
        end
        else begin
            state <= next_state;
            // Output is 1 only in states S3 and S4
            z <= (next_state == S3) | (next_state == S4);
        end
    end

endmodule