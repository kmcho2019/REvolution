module TopModule (
    input  a,
    input  b,
    output reg out_assign,
    output out_alwaysblock
);

    // Combinational always block with non-blocking assignment implements AND
    always @(*) begin
        out_assign <= a & b;
    end

    // Continuous assign implements AND directly
    assign out_alwaysblock = a & b;

endmodule