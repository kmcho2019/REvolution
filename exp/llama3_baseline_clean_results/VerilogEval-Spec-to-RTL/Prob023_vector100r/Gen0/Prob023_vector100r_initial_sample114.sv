module TopModule(
    input [99:0] in,
    output [99:0] out
);

    assign out = {<<{in}}; // Reverse the bit order of in and assign it to out

endmodule