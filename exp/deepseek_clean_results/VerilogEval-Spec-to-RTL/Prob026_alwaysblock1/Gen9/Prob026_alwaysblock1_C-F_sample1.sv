module TopModule (
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

    // Direct AND implementation using assign
    assign out_assign = a & b;

    // Combinational always block implementation
    // Using blocking assignment for pure combinational logic
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule