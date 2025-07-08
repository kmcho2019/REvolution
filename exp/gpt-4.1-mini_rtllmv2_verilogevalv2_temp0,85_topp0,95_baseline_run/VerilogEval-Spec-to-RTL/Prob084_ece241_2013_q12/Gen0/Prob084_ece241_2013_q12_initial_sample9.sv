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

    // Shift register operation
    always @(posedge clk) begin
        if (enable) begin
            Q <= {S, Q[7:1]};
        end
    end

    // 3-bit address formed by {A,B,C}
    wire [2:0] addr = {A, B, C};

    // Multiplexer to select the bit from Q based on address
    assign Z = Q[addr];

endmodule