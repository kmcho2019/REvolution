module TopModule(
    input  [31:0] in,
    output [31:0] out
);

    // Using bitwise shift operators to reverse the byte order
    assign out = (in >> 24) | ((in & 24'h00FF0000) >> 8) | ((in & 24'h0000FF00) << 8) | ((in & 24'h000000FF) << 24);

endmodule