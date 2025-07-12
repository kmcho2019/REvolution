module TopModule (
    input  [7:0] in,
    output       parity
);
    // Use Verilog reduction XOR operator to compute even parity bit
    assign parity = ^in;
endmodule