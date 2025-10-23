module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Common selection signal
    wire select_b = sel_b1 & sel_b2;

    // Implementation using continuous assignment with bitwise operations
    assign out_assign = (select_b & b) | (~select_b & a);

    // Implementation using procedural block with case statement
    always @(*) begin
        case (select_b)
            1'b1: out_always = b;
            default: out_always = a;
        endcase
    end
endmodule