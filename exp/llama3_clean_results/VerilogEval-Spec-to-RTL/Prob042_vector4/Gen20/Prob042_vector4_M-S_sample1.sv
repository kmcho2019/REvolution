module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    // Direct assignment leveraging Verilog's sign extension
    assign out = {24'b0, in}; // This will sign extend in to 32 bits

    // Alternatively, directly assigning will also sign extend
    // assign out = $signed(in); // Requires SystemVerilog

    // For standard Verilog (without SystemVerilog's $signed function), 
    // the above direct assignment with concatenation is the preferred method.

endmodule