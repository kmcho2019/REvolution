module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // One-hot state bits: only one bit high per state
    reg s0, s1, s2, s3, s4;
    reg ns0, ns1, ns2, ns3, ns4;

    // Synchronous state update with reset
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

    // Next state combinational logic
    always @(*) begin
        // Default no states active
        ns0 = 1'b0;
        ns1 = 1'b0;
        ns2 = 1'b0;
        ns3 = 1'b0;
        ns4 = 1'b0;

        // Based on current state and input x, set the next state one-hot
        if (s0) begin
            if (x)
                ns1 = 1'b1; // 000 -> 001 if x=1
            else
                ns0 = 1'b1; // 000 -> 000 if x=0
        end
        else if (s1) begin
            if (x)
                ns4 = 1'b1; // 001 -> 100 if x=1
            else
                ns1 = 1'b1; // 001 -> 001 if x=0
        end
        else if (s2) begin
            if (x)
                ns1 = 1'b1; // 010 -> 001 if x=1
            else
                ns2 = 1'b1; // 010 -> 010 if x=0
        end
        else if (s3) begin
            if (x)
                ns2 = 1'b1; // 011 -> 010 if x=1
            else
                ns1 = 1'b1; // 011 -> 001 if x=0
        end
        else if (s4) begin
            if (x)
                ns4 = 1'b1; // 100 -> 100 if x=1
            else
                ns3 = 1'b1; // 100 -> 011 if x=0
        end
        else begin
            // Should not occur: default to initial state
            ns0 = 1'b1;
        end
    end

    // Output z is 1 when in state S3 or S4
    assign z = s3 | s4;

endmodule