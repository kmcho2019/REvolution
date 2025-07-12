module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Continuous assign implementing AND directly
    assign out_assign = a & b;

    // Combinational always block implementing the same AND logic
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule