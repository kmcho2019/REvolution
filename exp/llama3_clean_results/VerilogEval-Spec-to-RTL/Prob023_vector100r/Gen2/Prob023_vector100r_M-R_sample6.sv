module TopModule (
    input  [99:0] in,
    output [99:0] out
);

    assign out = {<<{in}}; // Using bit reversal operator to reverse the bits

endmodule