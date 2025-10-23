module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Continuous assign calculates AND of inputs directly
    assign out_assign = a & b;

    // Combinational always block implements AND operation explicitly
    always @(*) begin
        if (a & b)
            out_alwaysblock = 1'b1;
        else
            out_alwaysblock = 1'b0;
    end

endmodule