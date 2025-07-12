module TopModule(
    input  [7:0] in,
    output [31:0] out
);
    // The following line maintains the simplicity and efficiency of the original solution
    // while allowing for synthesis tool optimizations. It directly achieves the sign extension
    // by replicating the sign bit 24 times and concatenating it with the original 8-bit number.
    assign out = { {24{in[7]}}, in };
    
    // For further PPA optimization, consider adding synthesis directives or attributes
    // if supported by the target technology, to guide the synthesis tool in generating
    // the most area- and power-efficient netlist.
endmodule