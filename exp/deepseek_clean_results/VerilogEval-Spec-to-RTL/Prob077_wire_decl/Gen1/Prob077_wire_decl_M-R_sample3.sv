module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // Declare regs for procedural assignment
    reg and1_out;
    reg and2_out;
    reg out_reg;
    
    // Implement logic in always block
    always @(*) begin
        and1_out = a & b;
        and2_out = c & d;
        out_reg = and1_out | and2_out;
    end
    
    // Continuous assignments for outputs
    assign out = out_reg;
    assign out_n = ~out;

endmodule