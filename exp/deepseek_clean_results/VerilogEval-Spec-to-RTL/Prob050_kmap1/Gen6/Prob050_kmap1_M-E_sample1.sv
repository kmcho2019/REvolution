module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Intermediate wire for the NOR result
    wire nor_result;
    
    // 3-input NOR gate detects the all-zero case
    assign nor_result = ~(a | b | c);
    
    // Inverter converts the NOR result to the desired output
    assign out = ~nor_result;
endmodule