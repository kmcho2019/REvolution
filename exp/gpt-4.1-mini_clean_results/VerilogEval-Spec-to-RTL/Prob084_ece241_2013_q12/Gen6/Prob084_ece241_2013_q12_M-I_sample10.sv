module TopModule (
    input        clk,
    input        enable,
    input        S,
    input        A,
    input        B,
    input        C,
    output       Z
);

    reg [7:0] Q;

    // Generate gated clock for shift register: clock pulses only when enable is high
    wire gated_clk = clk & enable;

    // 8-bit shift register triggered on gated clock
    // Since gated_clk toggles only when enable=1, no need for if(enable) inside always block
    always @(posedge gated_clk) begin
        Q[0] <= S;
        Q[1] <= Q[0];
        Q[2] <= Q[1];
        Q[3] <= Q[2];
        Q[4] <= Q[3];
        Q[5] <= Q[4];
        Q[6] <= Q[5];
        Q[7] <= Q[6];
    end

    // 8-to-1 multiplexer using direct vector indexing
    assign Z = Q[{A, B, C}];

endmodule