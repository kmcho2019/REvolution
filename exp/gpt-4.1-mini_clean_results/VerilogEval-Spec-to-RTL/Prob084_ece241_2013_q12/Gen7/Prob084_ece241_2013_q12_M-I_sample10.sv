module TopModule(
    input        clk,
    input        enable,
    input        S,
    input        A,
    input        B,
    input        C,
    output       Z
);

    reg [7:0] Q;

    // Shift register: shift in S at Q[0], shift right through Q[7] on enable
    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};
    end

    // Address select vector index: {C,B,A} with C as MSB to match ABC logic order
    wire [2:0] addr = {C,B,A};

    assign Z = Q[addr];

endmodule