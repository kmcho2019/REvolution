module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    
    // Custom selection function using XOR and AND
    wire custom_sel = (sel_b1 ^ sel_b2) & (sel_b1 | sel_b2);
    
    // Assign-based implementation using bitwise operations
    assign out_assign = (a & ~custom_sel) | (b & custom_sel);
    
    // Always-based implementation using case statement
    reg out_always_reg;
    always @(*) begin
        case ({sel_b1, sel_b2})
            2'b11: out_always_reg = b;
            default: out_always_reg = a;
        endcase
    end
    
    assign out_always = out_always_reg;
endmodule