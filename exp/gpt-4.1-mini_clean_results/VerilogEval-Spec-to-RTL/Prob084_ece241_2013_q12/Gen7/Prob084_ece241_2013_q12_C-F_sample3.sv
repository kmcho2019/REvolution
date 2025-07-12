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

    // Generate gated clock to minimize switching when enable=0
    wire gated_clk = clk & enable;

    // Use gated clock for shift register: shift right with S into Q[0]
    // This avoids unnecessary toggling of flip-flops when enable=0
    always @(posedge gated_clk) begin
        Q <= {Q[6:0], S};
    end

    // Multiplexer to select output Z based on ABC as index to Q
    assign Z = Q[{A, B, C}];

endmodule