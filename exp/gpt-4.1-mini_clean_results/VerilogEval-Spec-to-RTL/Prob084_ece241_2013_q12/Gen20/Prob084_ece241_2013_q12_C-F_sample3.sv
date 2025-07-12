module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    reg [7:0] Q;

    // 8-bit shift register with synchronous active-high enable
    // Shift right: new bit S shifted into Q[0] (LSB)
    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};
    end

    // Output Z is combinational mux selecting Q indexed by {A,B,C}
    assign Z = Q[{A, B, C}];

endmodule