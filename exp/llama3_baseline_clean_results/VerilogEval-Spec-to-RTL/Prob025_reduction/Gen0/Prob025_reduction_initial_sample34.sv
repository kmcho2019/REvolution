module TopModule(
    input [7:0] in,  // input 8-bit byte
    output parity   // output parity bit
);

assign parity = ^in; // calculate the parity bit using reduction XOR

endmodule