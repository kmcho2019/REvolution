module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Direct AND implementation using assign
    assign out_assign = a & b;
    
    // Equivalent implementation using always block
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule