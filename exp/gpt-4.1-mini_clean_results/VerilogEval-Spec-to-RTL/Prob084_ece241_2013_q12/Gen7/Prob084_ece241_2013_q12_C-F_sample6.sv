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

    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S}; // Shift in S at Q[0], shift left to Q[7]
        end
    end

    assign Z = Q[{A,B,C}];

endmodule