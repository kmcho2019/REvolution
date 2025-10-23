module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    reg [2:0] state;
    wire [2:0] next_state;

    // Parallel next state computation
    wire s0_next_0 = ~state[2] & ~state[1] & ~state[0] & ~x;
    wire s0_next_1 = ~state[2] & ~state[1] & ~state[0] & x;
    wire s1_next_0 = ~state[2] & ~state[1] & state[0] & ~x;
    wire s1_next_1 = ~state[2] & ~state[1] & state[0] & x;
    wire s2_next_0 = ~state[2] & state[1] & ~state[0] & ~x;
    wire s2_next_1 = ~state[2] & state[1] & ~state[0] & x;
    wire s3_next_0 = ~state[2] & state[1] & state[0] & ~x;
    wire s3_next_1 = ~state[2] & state[1] & state[0] & x;
    wire s4_next_0 = state[2] & ~state[1] & ~state[0] & ~x;
    wire s4_next_1 = state[2] & ~state[1] & ~state[0] & x;

    // Priority encoded next state selection
    assign next_state = 
        s0_next_0 ? 3'b000 :
        s0_next_1 ? 3'b001 :
        s1_next_0 ? 3'b001 :
        s1_next_1 ? 3'b100 :
        s2_next_0 ? 3'b010 :
        s2_next_1 ? 3'b001 :
        s3_next_0 ? 3'b001 :
        s3_next_1 ? 3'b010 :
        s4_next_0 ? 3'b011 :
        s4_next_1 ? 3'b100 :
        3'b000; // default case

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;
        else
            state <= next_state;
    end

    // Output logic (S3 or S4)
    assign z = (state == 3'b011) | (state == 3'b100);

endmodule