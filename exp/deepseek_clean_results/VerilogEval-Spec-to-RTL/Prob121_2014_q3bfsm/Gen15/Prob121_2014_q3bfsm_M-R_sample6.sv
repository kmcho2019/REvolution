module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    reg [2:0] state;
    wire [2:0] next_state;

    // Next state logic - each bit computed separately
    assign next_state[2] = (~state[2] & state[1] & ~state[0] & x) |  // 010->001 case
                          (state[2] & ~state[1] & ~state[0] & ~x);  // 100->011 case

    assign next_state[1] = (~state[2] & ~state[1] & state[0] & ~x) |  // 001->001 case
                          (~state[2] & state[1] & ~state[0]) |       // 010 stays or ->001
                          (~state[2] & state[1] & state[0] & ~x) |   // 011->001 case
                          (state[2] & ~state[1] & ~state[0] & x);     // 100->100 case

    assign next_state[0] = (~state[2] & ~state[1] & ~state[0] & x) |  // 000->001 case
                          (~state[2] & state[1] & state[0] & x) |     // 011->010 case
                          (state[2] & ~state[1] & ~state[0] & ~x);    // 100->011 case

    // State transition with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;
        else
            state <= next_state;
    end

    // Output logic remains the same
    assign z = (state == 3'b011) || (state == 3'b100);

endmodule