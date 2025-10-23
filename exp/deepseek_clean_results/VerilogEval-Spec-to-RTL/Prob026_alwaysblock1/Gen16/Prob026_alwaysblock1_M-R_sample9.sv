module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // AND gate using assign statement (direct continuous assignment)
    assign out_assign = a & b;

    // AND gate using always block (now directly assigning to output)
    always @(*) begin
        out_alwaysblock = a & b;
    end
endmodule