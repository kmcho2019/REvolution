module TopModule(
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    wire and_result;
    
    // Intermediate AND result
    assign and_result = a & b;

    // Assign output driven by intermediate wire
    assign out_assign = and_result;

    // Combinational always block assigns reg output using the intermediate wire
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule