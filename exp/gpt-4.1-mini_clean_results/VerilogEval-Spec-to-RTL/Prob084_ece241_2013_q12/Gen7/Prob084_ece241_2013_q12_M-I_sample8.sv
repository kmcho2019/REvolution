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

    // Shift register with synchronous enable
    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};  // Shift left: shift in S at LSB (Q[0]) which is MSB shifted in first as per problem statement
    end

    // Output multiplexer selecting Q based on {A,B,C} as address
    // Note: {C,B,A} gives the index with A as LSB, but problem says ABC as address,
    // so use {A,B,C} with A as MSB per problem or define clearly:
    // Problem states: when ABC=000 => Z=Q[0], ..., so ABC is the address from MSB to LSB: A = MSB, C=LSB
    // So we use address = {A,B,C}
    assign Z = Q[{A,B,C}];

endmodule