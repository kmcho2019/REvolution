module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot states representing pattern progression
    reg s0;  // Initial state (prev bit was 0)
    reg s1;  // 0
    reg s2;  // 01
    reg s3;  // 011
    reg s4;  // 0111
    reg s5;  // 01111
    reg s6;  // 011111
    reg s7;  // 0111111 (error condition)

    always @(posedge clk) begin
        if (reset) begin
            // Reset to initial state (prev bit was 0)
            s0 <= 1'b1;
            s1 <= 1'b0;
            s2 <= 1'b0;
            s3 <= 1'b0;
            s4 <= 1'b0;
            s5 <= 1'b0;
            s6 <= 1'b0;
            s7 <= 1'b0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            // Default outputs
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;

            // State transitions
            s0 <= (~in) & (s0 | s1 | (s2 & ~in) | (s3 & ~in) | (s4 & ~in) | (s5 & ~in) | (s6 & ~in));
            s1 <= (in & s0) | (in & s1 & ~s7);
            s2 <= (in & s1);
            s3 <= (in & s2);
            s4 <= (in & s3);
            s5 <= (in & s4);
            s6 <= (in & s5);
            s7 <= (in & s6) | (in & s7);

            // Output generation
            if (~in) begin
                if (s6) flag <= 1'b1;
                if (s5) disc <= 1'b1;
            end
            if (s7) err <= 1'b1;
        end
    end

endmodule