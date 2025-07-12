module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Assign-based implementation using nested ternary
    assign out_assign = sel_b1 ? (sel_b2 ? b : a) : a;
    
    // Always-based implementation using bitwise OR
    reg out_temp;
    always @(*) begin
        out_temp = (sel_b1 | sel_b2) == 2'b11 ? b : a;
    end
    assign out_always = out_temp;
endmodule