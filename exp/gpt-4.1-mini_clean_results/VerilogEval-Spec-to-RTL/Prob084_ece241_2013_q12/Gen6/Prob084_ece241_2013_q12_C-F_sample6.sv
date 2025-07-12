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

    // Shift register: shift right, new bit S into Q[0] on posedge clk when enable
    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};
    end

    // Direct vector indexing mux: select output Z = Q[{C,B,A}]
    assign Z = Q[{C,B,A}];

endmodule