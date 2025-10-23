module TopModule (
    input  clk,
    input  reset,
    input  x,
    output z
);

    // State bits (one-hot style signals for each state bit)
    reg s0, s1, s2, s3, s4;
    wire s0_next, s1_next, s2_next, s3_next, s4_next;

    // Synchronous reset flip-flops with next state logic from combinational assignments
    always @(posedge clk) begin
        if (reset) begin
            s0 <= 1'b1;
            s1 <= 1'b0;
            s2 <= 1'b0;
            s3 <= 1'b0;
            s4 <= 1'b0;
        end else begin
            s0 <= s0_next;
            s1 <= s1_next;
            s2 <= s2_next;
            s3 <= s3_next;
            s4 <= s4_next;
        end
    end

    // Next state logic expressed with boolean expressions for each state bit
    assign s0_next = (s0 & ~x) | (s1 & ~x) | (s2 & ~x);   // states 000, 001, 010 with x=0 remain or go to s0
    assign s1_next = (s0 & x) | (s1 & ~x) | (s2 & x) | (s3 & ~x);
    assign s2_next = (s3 & x);
    assign s3_next = (s4 & ~x);
    assign s4_next = (s1 & x) | (s4 & x);

    // Output z is high if in states 011 (s3) or 100 (s4)
    assign z = s3 | s4;

endmodule