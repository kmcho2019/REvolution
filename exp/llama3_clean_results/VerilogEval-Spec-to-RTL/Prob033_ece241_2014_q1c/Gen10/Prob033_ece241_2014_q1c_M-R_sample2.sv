// TopModule that integrates the adder and overflow detection
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    // Perform the addition using a carry-lookahead adder
    assign s = a + b;

    // Detect signed overflow using a separate adder
    assign overflow = ($signed(a) + $signed(b) > $signed(127) || 
                       $signed(a) + $signed(b) < $signed(-128));

endmodule