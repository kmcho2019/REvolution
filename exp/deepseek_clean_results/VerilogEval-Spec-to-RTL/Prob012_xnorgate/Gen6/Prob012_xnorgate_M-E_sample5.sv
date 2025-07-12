module TopModule (
    input a,
    input b,
    output out
);
    // Use a 2:1 MUX to implement XNOR
    // out = (a == b) ? 1 : 0
    assign out = (a == b) ? 1'b1 : 1'b0;
endmodule