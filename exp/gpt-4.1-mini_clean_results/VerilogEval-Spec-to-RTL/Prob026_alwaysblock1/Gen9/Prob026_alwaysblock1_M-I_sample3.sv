module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Directly assign the AND of inputs to out_assign
    assign out_assign = a & b;

    // Use a combinational always block to assign the AND of inputs to out_alwaysblock
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule