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
            Q <= {Q[6:0], S}; // Shift left, insert S at Q[0]
        end
    end

    wire [2:0] addr = {A, B, C};
    assign Z = Q[addr];

endmodule