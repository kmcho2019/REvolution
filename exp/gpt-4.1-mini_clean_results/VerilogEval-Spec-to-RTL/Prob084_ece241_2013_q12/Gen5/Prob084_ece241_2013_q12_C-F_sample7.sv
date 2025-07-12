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

    // 8-bit shift register: shift-in S at Q[0] on posedge clk if enable
    // Using concatenation for efficient and clear shifting
    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};
    end

    // 8-to-1 multiplexer: direct indexed vector read for minimal logic
    // {A,B,C} forms a 3-bit index selecting Q bit for output Z
    assign Z = Q[{A,B,C}];

endmodule