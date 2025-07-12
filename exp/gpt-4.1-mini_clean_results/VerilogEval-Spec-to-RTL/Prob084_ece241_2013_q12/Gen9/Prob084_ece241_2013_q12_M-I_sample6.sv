module TopModule(
    input        clk,
    input        enable,
    input        S,
    input        A,
    input        B,
    input        C,
    output       Z
);

reg [7:0] Q;  // Q[7] is MSB shifted in first, Q[0] is LSB

always @(posedge clk) begin
    if (enable)
        Q <= {Q[6:0], S};  // Shift left, MSB shifted in first
end

// Output Z is selected based on inputs A,B,C as an index from Q
assign Z = Q[{A,B,C}];

endmodule