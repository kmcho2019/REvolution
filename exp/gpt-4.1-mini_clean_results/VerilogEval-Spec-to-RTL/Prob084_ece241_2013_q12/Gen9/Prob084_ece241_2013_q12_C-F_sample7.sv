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

    // Shift register: shift right with S into Q[0] on posedge clk if enable
    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};
    end

    // Direct indexed 8-to-1 multiplexer from Q using ABC as selector
    assign Z = Q[{A,B,C}];

endmodule