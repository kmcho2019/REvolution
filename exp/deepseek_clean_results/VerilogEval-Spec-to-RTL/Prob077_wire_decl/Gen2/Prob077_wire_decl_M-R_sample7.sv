module TopModule (
    input a,
    input b,
    input c,
    input d,
    output reg out,
    output out_n
);

    // First layer: AND gates
    reg and1_out;
    reg and2_out;
    
    always @(*) begin
        and1_out = a & b;
        and2_out = c & d;
        out = and1_out | and2_out;
    end
    
    // Inverted output remains continuous assignment
    assign out_n = ~out;

endmodule