module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Priority encoded selection
    // [sel_b2, sel_b1] forms a 2-bit priority code
    // 11, 10: highest priority (choose b)
    // 01: medium priority (choose b)
    // 00: lowest priority (choose a)
    
    // Assign implementation
    assign out_assign = (sel_b2) ? b : 
                       (sel_b1) ? b : a;
    
    // Always implementation
    reg out_always_reg;
    always @(*) begin
        case ({sel_b2, sel_b1})
            2'b00: out_always_reg = a;
            2'b01: out_always_reg = b;
            2'b10: out_always_reg = b;
            2'b11: out_always_reg = b;
            default: out_always_reg = a;
        endcase
    end
    
    assign out_always = out_always_reg;
endmodule