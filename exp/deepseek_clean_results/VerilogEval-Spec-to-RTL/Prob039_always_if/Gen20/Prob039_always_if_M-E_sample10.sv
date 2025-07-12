module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output reg out_always
);
    // Assign-based implementation using explicit AND-OR structure
    assign out_assign = (~sel_b1 & ~sel_b2) ? a :
                        ( sel_b1 & ~sel_b2) ? a :
                        (~sel_b1 &  sel_b2) ? a :
                        b;  // only case left is (sel_b1 & sel_b2)

    // Always-based implementation using case statement
    always @(*) begin
        case ({sel_b1, sel_b2})
            2'b00: out_always = a;
            2'b01: out_always = a;
            2'b10: out_always = a;
            2'b11: out_always = b;
        endcase
    end
endmodule