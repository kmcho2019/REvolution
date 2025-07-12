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

    // 8-bit shift register with synchronous enable, shift-in at Q[0]
    always @(posedge clk) begin
        if (enable) begin
            Q[0] <= S;
            Q[1] <= Q[0];
            Q[2] <= Q[1];
            Q[3] <= Q[2];
            Q[4] <= Q[3];
            Q[5] <= Q[4];
            Q[6] <= Q[5];
            Q[7] <= Q[6];
        end
    end

    // 8-to-1 multiplexer implemented as direct indexed vector read
    // Select is {A,B,C} interpreted as a 3-bit unsigned index into Q
    assign Z = Q[{A, B, C}];

endmodule