module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // First level MUX: select based on 'a'
    // When a=1: output is 1 (covers most cases)
    // When a=0: use second MUX based on b and c
    wire mux2_out;
    
    // Second level MUX: when a=0, select based on b
    assign mux2_out = b ? 1'b1 : c;
    
    // Final output
    assign out = a ? 1'b1 : mux2_out;
endmodule