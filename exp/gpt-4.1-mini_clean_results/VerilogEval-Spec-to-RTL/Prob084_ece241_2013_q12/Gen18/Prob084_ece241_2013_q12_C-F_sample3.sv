module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    reg [7:0] Q;

    // 8-bit shift register with synchronous active-high enable
    // Shift right on each clock, shifting in S at LSB (Q[0])
    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};
    end

    // Combinational 8-to-1 multiplexer for output Z, indexed by {A,B,C}
    assign Z = Q[{A, B, C}];

endmodule