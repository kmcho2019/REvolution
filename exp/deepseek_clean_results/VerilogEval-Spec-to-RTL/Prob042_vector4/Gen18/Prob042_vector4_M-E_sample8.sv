module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    // Define extension patterns
    wire [23:0] ext_pattern = {24{in[7]}};
    
    // Alternative implementation using pattern selection
    assign out = {ext_pattern, in};

    /*
    * Architectural differences:
    * - Explicitly creates extension pattern first
    * - Then concatenates with input
    * - Functionally identical but shows different structural approach
    * - May map differently to certain architectures
    */
endmodule