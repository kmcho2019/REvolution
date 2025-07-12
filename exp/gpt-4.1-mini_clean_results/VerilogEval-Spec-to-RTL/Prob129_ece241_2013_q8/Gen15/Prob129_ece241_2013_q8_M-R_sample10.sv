module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

    // One-hot state encoding: each bit represents a state
    localparam 
        S_IDLE_BIT = 3'b001,
        S_1_BIT    = 3'b010,
        S_10_BIT   = 3'b100;

    reg [2:0] state, next_state;

    // Next state logic as combinational continuous assignments
    wire s_idle   = state[0];
    wire s_1      = state[1];
    wire s_10     = state[2];

    wire next_idle  = (~x & s_idle) | (~x & s_10);
    wire next_1     = (x & s_idle) | (x & s_1) | (x & s_10);
    wire next_10    = (~x & s_1);

    assign next_state = {next_10, next_1, next_idle};

    // Output logic: z = 1 when in S_10 and input x is high (Mealy)
    assign z = s_10 & x;

    // State flip-flops with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE_BIT;
        else
            state <= next_state;
    end

endmodule