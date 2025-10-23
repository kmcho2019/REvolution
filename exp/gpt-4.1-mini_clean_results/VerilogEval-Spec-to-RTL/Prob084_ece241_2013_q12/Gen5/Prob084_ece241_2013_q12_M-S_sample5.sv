module TopModule (
    input       clk,
    input       enable,
    input       S,
    input       A,
    input       B,
    input       C,
    output      Z
);

    reg [7:0] Q;

    // Shift register: shift right on enable, shift-in S at Q[0]
    always @(posedge clk) begin
        if (enable)
            Q <= {S, Q[7:1]};
    end

    // Multiplexer: output bit selected by {A,B,C} from Q
    assign Z = Q[{A,B,C}];

endmodule