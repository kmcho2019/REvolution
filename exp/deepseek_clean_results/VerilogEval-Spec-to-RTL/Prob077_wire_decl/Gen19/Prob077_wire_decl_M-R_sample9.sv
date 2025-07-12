module TopModule (
    input a,
    input b,
    input c,
    input d,
    output reg out,
    output reg out_n
);
    reg and_ab, and_cd;
    
    always @(*) begin
        // First layer: AND operations
        and_ab = a & b;
        and_cd = c & d;
        
        // Second layer: OR operation
        out = and_ab | and_cd;
        
        // Inverted output
        out_n = ~out;
    end
endmodule