module TopModule (
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output Z
);

    reg [7:0] Q;

    // Shift register: on posedge clk, if enable is high, shift left with S into Q[0]
    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};
    end

    // Output Z is the Q bit indexed by the 3-bit address formed by ABC
    assign Z = Q[{A,B,C}];

endmodule