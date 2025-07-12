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

    // 8-bit shift register with synchronous enable
    // Shift-in S at Q[0], shift right (toward Q[7])
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end

    // 3-bit index from inputs A,B,C
    wire [2:0] index = {A, B, C};

    // Output Z selected by indexed mux from Q
    assign Z = Q[index];

endmodule