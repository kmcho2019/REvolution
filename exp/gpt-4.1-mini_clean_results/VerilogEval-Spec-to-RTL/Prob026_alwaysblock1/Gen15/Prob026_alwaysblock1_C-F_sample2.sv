module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Internal wire implementing AND of inputs for continuous assign output
    wire and_result = a & b;

    // Continuous assignment driving out_assign directly from the wire
    assign out_assign = and_result;

    // Combinational always block implementing AND directly from inputs
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule