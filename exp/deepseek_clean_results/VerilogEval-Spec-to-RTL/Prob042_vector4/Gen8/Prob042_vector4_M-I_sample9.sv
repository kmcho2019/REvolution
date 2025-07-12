module TopModule (
    input  [7:0] in,    // 8-bit signed input value
    output [31:0] out   // 32-bit sign-extended output
);
    localparam INPUT_WIDTH = 8;
    localparam OUTPUT_WIDTH = 32;
    
    // Sign-extension using continuous assignment with cleaner syntax
    assign out = {{(OUTPUT_WIDTH-INPUT_WIDTH){in[INPUT_WIDTH-1]}}, in};
endmodule