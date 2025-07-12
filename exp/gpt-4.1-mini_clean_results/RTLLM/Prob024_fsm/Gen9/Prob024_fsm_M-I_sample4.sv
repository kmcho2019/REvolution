module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // One-hot state encoding
    // s0: no bits matched
    // s1: matched '1'
    // s2: matched '10'
    // s3: matched '100'
    // s4: matched '1001'

    reg s0, s1, s2, s3, s4;
    reg ns0, ns1, ns2, ns3, ns4;

    // Next-state logic combinational
    always @(*) begin
        // default next state = 0
        ns0 = 0; ns1 = 0; ns2 = 0; ns3 = 0; ns4 = 0;

        // s0 transitions
        if (s0) begin
            if (IN == 1'b1)
                ns1 = 1'b1;
            else
                ns0 = 1'b1;
        end

        // s1 transitions
        if (s1) begin
            if (IN == 1'b0)
                ns2 = 1'b1;
            else
                ns1 = 1'b1;
        end

        // s2 transitions
        if (s2) begin
            if (IN == 1'b0)
                ns3 = 1'b1;
            else
                ns1 = 1'b1;
        end

        // s3 transitions
        if (s3) begin
            if (IN == 1'b1)
                ns4 = 1'b1;
            else
                ns0 = 1'b1;
        end

        // s4 transitions (overlap)
        if (s4) begin
            if (IN == 1'b1)
                ns1 = 1'b1;
            else
                ns2 = 1'b1;
        end
    end

    // Sequential logic with synchronous reset
    always @(posedge CLK) begin
        if (RST) begin
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

    // Mealy output: MATCH is high when in s4 and input IN=1 (end of sequence)
    assign MATCH = s4 & IN;

endmodule