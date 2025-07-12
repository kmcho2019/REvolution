module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (j ^ k)      // When J and K are different
        Q <= j;     // Q takes J's value
    else if (j)     // When both are 1
        Q <= ~Q;    // Toggle
    // else         // When both are 0, Q remains (implicit)
end

endmodule