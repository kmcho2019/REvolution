module TopModule(
    input        in,
    input  [9:0] state,
    output reg [9:0] next_state,
    output reg       out1,
    output reg       out2
);

reg [9:0] ns0, ns1, ns2, ns3, ns4, ns5, ns6, ns7, ns8, ns9;
reg       o1_7, o2_7, o1_8, o2_8, o1_9, o2_9;

always @(*) begin
    // Default no next state and outputs
    ns0 = 10'b0; ns1 = 10'b0; ns2 = 10'b0; ns3 = 10'b0; ns4 = 10'b0;
    ns5 = 10'b0; ns6 = 10'b0; ns7 = 10'b0; ns8 = 10'b0; ns9 = 10'b0;
    o1_7 = 1'b0; o2_7 = 1'b0; o1_8 = 1'b0; o2_8 = 1'b0; o1_9 = 1'b0; o2_9 = 1'b0;

    // S0 (0,0)
    if(state[0]) begin
        if(in == 1'b0) ns0[0] = 1'b1; else ns1[1] = 1'b1;
    end

    // S1 (0,0)
    if(state[1]) begin
        if(in == 1'b0) ns0[0] = 1'b1; else ns2[2] = 1'b1;
    end

    // S2 (0,0)
    if(state[2]) begin
        if(in == 1'b0) ns0[0] = 1'b1; else ns3[3] = 1'b1;
    end

    // S3 (0,0)
    if(state[3]) begin
        if(in == 1'b0) ns0[0] = 1'b1; else ns4[4] = 1'b1;
    end

    // S4 (0,0)
    if(state[4]) begin
        if(in == 1'b0) ns0[0] = 1'b1; else ns5[5] = 1'b1;
    end

    // S5 (0,0)
    if(state[5]) begin
        if(in == 1'b0) ns8[8] = 1'b1; else ns6[6] = 1'b1;
    end

    // S6 (0,0)
    if(state[6]) begin
        if(in == 1'b0) ns9[9] = 1'b1; else ns7[7] = 1'b1;
    end

    // S7 (0,1)
    if(state[7]) begin
        if(in == 1'b0) ns0[0] = 1'b1; else ns7[7] = 1'b1;
        o1_7 = 1'b0;
        o2_7 = 1'b1;
    end

    // S8 (1,0)
    if(state[8]) begin
        if(in == 1'b0) ns0[0] = 1'b1; else ns1[1] = 1'b1;
        o1_8 = 1'b1;
        o2_8 = 1'b0;
    end

    // S9 (1,1)
    if(state[9]) begin
        if(in == 1'b0) ns0[0] = 1'b1; else ns1[1] = 1'b1;
        o1_9 = 1'b1;
        o2_9 = 1'b1;
    end

    // Combine partial next states by OR
    next_state = ns0 | ns1 | ns2 | ns3 | ns4 | ns5 | ns6 | ns7 | ns8 | ns9;

    // Combine outputs from states with outputs
    out1 = (state[7] & o1_7) | (state[8] & o1_8) | (state[9] & o1_9);
    out2 = (state[7] & o2_7) | (state[8] & o2_8) | (state[9] & o2_9);
end

endmodule