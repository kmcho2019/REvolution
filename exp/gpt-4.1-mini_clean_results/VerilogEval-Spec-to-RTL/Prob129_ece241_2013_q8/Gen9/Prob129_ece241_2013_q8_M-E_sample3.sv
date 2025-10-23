module TopModule (
    input  clk,
    input  aresetn, // async reset active low (negative edge)
    input  x,
    output z
);

    // One-hot state flip-flops
    reg S0, S1, S2;

    // Asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            S0 <= 1'b1;  // start in state S0
            S1 <= 1'b0;
            S2 <= 1'b0;
        end else begin
            // Next state logic
            // S0: no match yet
            //   - if x=1, go to S1
            //   - else stay S0
            S0 <= (~x & S0) | (~x & S2); // also from S2 if x=0, return to S0

            // S1: detected '1'
            //   - if x=0, go to S2 (detected '10')
            //   - else remain in S1 (consecutive ones)
            S1 <= (x & S0) | (x & S1) | (x & S2); 
            // From S0,S1,S2 if x=1, go to S1 (handles overlapping sequences)

            // S2: detected '10'
            //   - if x=1, z asserted, and next is S1 (since last input is '1')
            //   - if x=0, go back to S0
            S2 <= (~x & S1);
        end
    end

    // Output logic: z=1 if current state is S2 and x=1 (final bit in "101")
    assign z = S2 & x;

endmodule