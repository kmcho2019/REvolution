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

    // Shift register with vector and concatenation
    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};
    end

    // Multiplexer using direct vector indexing by concatenated ABC inputs
    assign Z = Q[{A,B,C}];

endmodule