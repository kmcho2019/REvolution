module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // One-hot state encoding for 5 states representing matched bits in "10011"
    // S0 = no match (00001)
    // S1 = matched '1'       (00010)
    // S2 = matched '10'      (00100)
    // S3 = matched '100'     (01000)
    // S4 = matched '1001'    (10000)
    reg [4:0] state, next_state;

    // Assign MATCH as a Mealy output:
    // MATCH = 1 when current state is S4 and IN=1 (completing "10011" sequence)
    assign MATCH = (state[4] && IN);

    // Next state logic using one-hot encoding and combinational assign
    // For clarity, name each bit
    wire S0 = state[0];
    wire S1 = state[1];
    wire S2 = state[2];
    wire S3 = state[3];
    wire S4 = state[4];

    // Compute each next state bit
    wire next_S0;
    wire next_S1;
    wire next_S2;
    wire next_S3;
    wire next_S4;

    // State transition logic:
    // From S0:
    //   if IN=1 -> S1 else S0
    assign next_S0 = (S0 && ~IN)             // stay in S0 if IN=0
                   | (S1 && IN == 0 && 0)   // will define below, better to express directly
                   | (S2 && IN == 0 && 0)   // etc. Use correct conditions below
                   | (S3 && IN == 0 && 0)   // Use clearer logic below

                   // Actually it's cleaner to write logic per next state rather than next_S0
                   // So, redo logic per next_state bit:

    // next_S1 = from:
    //   S0 & IN=1
    //   S1 & IN=1 (stay)
    //   S2 & IN=1 (restart S1)
    //   S4 & IN=1 (overlap restart)
    assign next_S1 = (S0 && IN) 
                   | (S1 && IN) 
                   | (S2 && IN)
                   | (S4 && IN);

    // next_S2 = from:
    //   S1 & IN=0
    //   S4 & IN=0
    assign next_S2 = (S1 && ~IN) 
                   | (S4 && ~IN);

    // next_S3 = from:
    //   S2 & IN=0
    assign next_S3 = (S2 && ~IN);

    // next_S4 = from:
    //   S3 & IN=1
    assign next_S4 = (S3 && IN);

    // next_S0 = all other cases (fallback)
    // i.e., when none of the above are true
    assign next_S0 = ~(next_S1 | next_S2 | next_S3 | next_S4);

    // Combine next_state bits
    assign next_state = {next_S4, next_S3, next_S2, next_S1, next_S0};

    // Sequential logic for state update and reset
    always @(posedge CLK or posedge RST) begin
        if (RST)
            state <= 5'b00001; // S0 is 1
        else
            state <= next_state;
    end

    // Initialize state at start-up (optional)
    initial begin
        state = 5'b00001;
    end

endmodule