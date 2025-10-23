module TopModule (
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);

    // out_assign is combinational AND implemented with assign
    assign out_assign = a & b;

    // out_alwaysblock implements the same AND directly in always block
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule