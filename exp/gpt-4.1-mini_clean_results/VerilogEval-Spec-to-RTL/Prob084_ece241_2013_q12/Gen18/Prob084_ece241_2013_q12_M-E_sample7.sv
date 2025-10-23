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

    // Shift register: on posedge clk and enable, shift left, shifting in S at Q[0]
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end

    // Output Z is selected by the 3-bit address formed by {A,B,C}
    assign Z = Q[{A,B,C}];

endmodule