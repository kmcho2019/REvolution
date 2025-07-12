module TopModule(
    input  [99:0] in,
    output [99:0] out
);

    assign out = {<<{in}}; // Using the {<<{vector}} syntax to reverse the bits of the input vector

endmodule