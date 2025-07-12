module TopModule (
    input x,
    input y,
    output z
);
    assign z = x ~^ y;  // Most concise XNOR implementation
endmodule