module TopModule(
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);

    // Direct AND operation in assign
    assign out_assign = a & b;

    // Direct AND operation in always block
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule