module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Continuous assignment using concatenated select bits
    assign out_assign = ({sel_b1, sel_b2} == 2'b11) ? b : a;
    
    // Procedural implementation with case statement
    always @(*) begin
        case ({sel_b1, sel_b2})
            2'b11: out_always = b;
            default: out_always = a;
        endcase
    end
endmodule