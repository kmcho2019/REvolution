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

    // Shift register with synchronous enable
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end

    // 3-bit address from inputs A,B,C
    wire [2:0] addr = {A,B,C};

    // Multiplexer to select Q[addr]
    assign Z = Q[addr];

endmodule