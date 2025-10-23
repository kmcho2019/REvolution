module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output reg out_always
);
    // Novel bitwise implementation for assign
    wire [1:0] sel_vec = {sel_b1, sel_b2};
    assign out_assign = (a & ~(&sel_vec)) | (b & &sel_vec);
    
    // Case statement implementation for always block
    always @(*) begin
        case ({sel_b1, sel_b2})
            2'b11: out_always = b;
            default: out_always = a;
        endcase
    end
endmodule