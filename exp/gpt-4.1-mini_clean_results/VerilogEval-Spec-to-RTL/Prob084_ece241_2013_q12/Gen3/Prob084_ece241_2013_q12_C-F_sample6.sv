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

    // 8-bit shift register (MSB shifted in first to Q[0])
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // Shift left: Q[0] <= S, Q[1] <= Q[0], ...
        end
    end

    // 3-bit select signal formed by concatenating inputs A,B,C
    wire [2:0] sel = {A, B, C};

    // 8-to-1 multiplexer selecting Q[sel]
    assign Z = Q[sel];

endmodule