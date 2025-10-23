module TopModule (
    input        clk,
    input        enable,
    input        S,
    input        A,
    input        B,
    input        C,
    output       Z
);

    reg [7:0] Q;  // Q[0] is the first flip-flop output (MSB shifted in first)

    // Shift register: on posedge clk, shift left by one if enable is high, shift in S at Q[0]
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end

    // Output Z is the selected bit from Q indexed by {A,B,C}
    assign Z = Q[{A, B, C}];

endmodule