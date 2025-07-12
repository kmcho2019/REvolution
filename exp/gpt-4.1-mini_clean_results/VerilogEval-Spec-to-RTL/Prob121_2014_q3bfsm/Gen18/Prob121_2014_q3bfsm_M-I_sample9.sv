module TopModule (
    input  clk,
    input  reset,
    input  x,
    output reg z
);

    // One-hot state encoding: s0=state000, s1=state001, s2=state010, s3=state011, s4=state100
    reg s0, s1, s2, s3, s4;
    reg ns0, ns1, ns2, ns3, ns4;

    always @(*) begin
        // Default next states to zero
        ns0 = 0; ns1 = 0; ns2 = 0; ns3 = 0; ns4 = 0;

        // Next-state logic per current state and input x
        if (s0)
            if (x) ns1 = 1; else ns0 = 1;
        else if (s1)
            if (x) ns4 = 1; else ns1 = 1;
        else if (s2)
            if (x) ns1 = 1; else ns2 = 1;
        else if (s3)
            if (x) ns2 = 1; else ns1 = 1;
        else if (s4)
            if (x) ns4 = 1; else ns3 = 1;
        else
            ns0 = 1; // default to initial state if none active
    end

    always @(posedge clk) begin
        if (reset) begin
            s0 <= 1;
            s1 <= 0;
            s2 <= 0;
            s3 <= 0;
            s4 <= 0;
            z  <= 0;
        end else begin
            s0 <= ns0;
            s1 <= ns1;
            s2 <= ns2;
            s3 <= ns3;
            s4 <= ns4;
            // Registered output based on current state
            z  <= s3 | s4;
        end
    end

endmodule