module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

    // One-hot state encoding: each bit represents a state
    // S_IDLE = state[0], S_1 = state[1], S_10 = state[2]
    reg [2:0] state, next_state;

    // Combinational next state logic using assign
    wire ns_idle, ns_1, ns_10;

    // From S_IDLE
    assign ns_idle = (state[0] && ~x);
    assign ns_1    = (state[0] && x);

    // From S_1
    // Stay in S_1 if x==1, else to S_10
    assign ns_1    = ns_1 | (state[1] && x);
    assign ns_10   = (state[1] && ~x);

    // From S_10
    // Move to S_1 if x==1 else S_IDLE
    assign ns_1    = ns_1 | (state[2] && x);
    assign ns_idle = ns_idle | (state[2] && ~x);

    // Collect next_state signals
    always @(*) begin
        next_state = 3'b000;
        if (ns_idle)
            next_state[0] = 1'b1;
        if (ns_1)
            next_state[1] = 1'b1;
        if (ns_10)
            next_state[2] = 1'b1;
    end

    // Output logic (Mealy): z asserted when in S_10 and x==1
    assign z = state[2] & x;

    // Sequential state update with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= 3'b001; // S_IDLE asserted
        else
            state <= next_state;
    end

endmodule