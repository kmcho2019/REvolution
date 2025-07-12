module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    wire and_result;

    // Compute the AND result with a continuous assignment
    assign and_result = a & b;

    // Assign the continuous output directly from the intermediate wire
    assign out_assign = and_result;

    // Combinational always block assigns output from the intermediate wire
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule