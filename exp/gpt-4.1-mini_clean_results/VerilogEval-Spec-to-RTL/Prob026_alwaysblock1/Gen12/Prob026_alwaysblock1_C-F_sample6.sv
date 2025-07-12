module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Internal wire implementing AND of inputs
    wire and_result = a & b;

    // Continuous assignment driving out_assign
    assign out_assign = and_result;

    // Combinational always block driving out_alwaysblock from the same wire
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule