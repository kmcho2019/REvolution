module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // One-hot state encoding
    // S0 = 3'b001 : waiting for '1'
    // S1 = 3'b010 : matched '1'
    // S2 = 3'b100 : matched "10"
    reg S0, S1, S2;
    reg nS0, nS1, nS2; // next states combinational signals

    // Next state logic (combinational)
    always @(*) begin
        // Default: all next states low
        nS0 = 1'b0;
        nS1 = 1'b0;
        nS2 = 1'b0;

        if (S0) begin
            // From S0: if x=1 go to S1 else stay in S0
            if (x)
                nS1 = 1'b1;
            else
                nS0 = 1'b1;
        end else if (S1) begin
            // From S1: if x=0 go to S2 else stay in S1
            if (~x)
                nS2 = 1'b1;
            else
                nS1 = 1'b1;
        end else if (S2) begin
            // From S2: if x=1 go to S1 else to S0
            if (x)
                nS1 = 1'b1;
            else
                nS0 = 1'b1;
        end else begin
            // Safety fallback: go to S0 if none set
            nS0 = 1'b1;
        end
    end

    // Output logic: Mealy output asserted when in S2 and x=1 (sequence "101" detected)
    always @(*) begin
        z = (S2 && x);
    end

    // Sequential logic: State registers with asynchronous active-low reset on negedge aresetn
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            S0 <= 1'b1; // Start in state S0
            S1 <= 1'b0;
            S2 <= 1'b0;
        end else begin
            S0 <= nS0;
            S1 <= nS1;
            S2 <= nS2;
        end
    end

endmodule