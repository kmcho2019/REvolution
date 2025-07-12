module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output reg out_always
);
    // Continuous assignment implementation using priority OR
    assign out_assign = (a & ~(sel_b1 & sel_b2)) | (b & sel_b1 & sel_b2);

    // Procedural always implementation using XOR selection
    always @(*) begin
        out_always = (a & (sel_b1 ^ sel_b2)) | (b & ~(sel_b1 ^ sel_b2)) | 
                    (b & sel_b1 & sel_b2);
    end
endmodule