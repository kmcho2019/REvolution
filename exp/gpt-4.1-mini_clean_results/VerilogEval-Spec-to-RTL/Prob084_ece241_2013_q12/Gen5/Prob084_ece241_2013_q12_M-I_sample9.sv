module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    reg [7:0] Q;

    // 8-bit shift register with synchronous enable, shift in S at Q[0]
    always @(posedge clk) begin
        if (enable) begin
            Q <= {S, Q[7:1]};
        end
    end

    // 8-to-1 multiplexer via direct indexing of Q with 3-bit address {C,B,A}
    // Note: The problem states that ABC=000 selects Q[0], ABC=001 selects Q[1], etc.
    // The bits are A,B,C as inputs, so concatenate them in the order {C,B,A} or {A,B,C}?
    // The problem specifies "when ABC=000, Z=Q[0]", "when ABC=001, Z=Q[1]", so the LSB corresponds to C.
    // Therefore, index = {C,B,A} reversed or {A,B,C}? The problem input order is A,B,C, so to get 0..7, index = {C,B,A} reversed
    // Let's confirm: ABC=000 (A=0,B=0,C=0) select Q[0], so index = {C,B,A} = 000 = 0 good
    // ABC=001 (A=0,B=0,C=1) select Q[1], index= {C,B,A} = 100=4 (wrong), {A,B,C} = 001=1 correct
    // So index should be {A,B,C}, so we index Q[{A,B,C}] to get correct mapping.

    assign Z = Q[{A,B,C}];

endmodule