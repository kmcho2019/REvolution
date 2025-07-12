module TopModule (
    input a,
    input b,
    input c,
    input d,
    output reg out,
    output out_n
);

    // First layer: AND gates
    wire and1_out;
    wire and2_out;
    
    // Procedural implementation
    always @(*) begin
        and1_out = a & b;
        and2_out = c & d;
        out = and1_out | and2_out;
    end
    
    // Continuous assignment for inversion
    assign out_n = ~out;

endmodule