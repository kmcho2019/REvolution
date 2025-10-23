module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);
    // Novel encoding scheme
    wire choose_b = sel_b1 & sel_b2;
    wire choose_a = ~choose_b;
    
    // Implementation 1: Bitwise operation with continuous assignment
    assign out_assign = (b & choose_b) | (a & choose_a);
    
    // Implementation 2: Same logic with procedural block
    always @(*) begin
        out_always = (b & choose_b) | (a & choose_a);
    end
endmodule