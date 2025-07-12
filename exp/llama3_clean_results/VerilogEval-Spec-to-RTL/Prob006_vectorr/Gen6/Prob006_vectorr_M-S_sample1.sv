module TopModule(
    input  [7:0] in,
    output [7:0] out
);

    assign out = {<<8{in}}; // Reverse the bits of the input port

endmodule