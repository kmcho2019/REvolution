module TopModule (
    input        clk,
    input        enable,
    input        S,
    input        A,
    input        B,
    input        C,
    output       Z
);

    reg [7:0] Q;  // Q[0] is LSB, newest bit shifted in; Q[7] is MSB, oldest bit

    // Shift register: on enable, shift left and shift in S at Q[0]
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end

    // Use {A,B,C} directly as an index to select output bit Z from Q
    assign Z = Q[{A,B,C}];

endmodule