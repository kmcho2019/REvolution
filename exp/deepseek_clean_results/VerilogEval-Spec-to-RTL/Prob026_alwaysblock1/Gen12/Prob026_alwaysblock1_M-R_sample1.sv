module TopModule (
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);
    // Continuous assignment style
    assign out_assign = a & b;
    
    // Always block style with if-else
    always @(*) begin
        if (a && b)
            out_alwaysblock = 1'b1;
        else
            out_alwaysblock = 1'b0;
    end
endmodule