module TopModule (
    input  clk,
    input  reset,
    input  x,
    output z
);

    // One-hot encoded states as individual bits
    reg s0, s1, s2, s3, s4;

    // Next state signals (combinational)
    wire ns0, ns1, ns2, ns3, ns4;

    // Next state logic derived directly from given FSM table
    // State 000 (s0)
    assign ns0 = (s0 & ~x) | (s1 & ~x) | (s2 & ~x);
    // State 001 (s1)
    assign ns1 = (s0 & x) | (s1 & ~x) | (s2 & x) | (s3 & ~x);
    // State 010 (s2)
    assign ns2 = s3 & x;
    // State 011 (s3)
    assign ns3 = s4 & ~x;
    // State 100 (s4)
    assign ns4 = (s1 & x) | (s4 & x);

    // Output logic: z=1 in states s3 or s4
    assign z = s3 | s4;

    // Synchronous process for one-hot state update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            s0 <= 1'b1;
            s1 <= 1'b0;
            s2 <= 1'b0;
            s3 <= 1'b0;
            s4 <= 1'b0;
        end else begin
            s0 <= ns0;
            s1 <= ns1;
            s2 <= ns2;
            s3 <= ns3;
            s4 <= ns4;
        end
    end

endmodule