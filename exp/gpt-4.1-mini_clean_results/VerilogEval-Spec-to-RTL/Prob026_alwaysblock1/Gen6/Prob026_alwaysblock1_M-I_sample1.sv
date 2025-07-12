module TopModule(
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    wire and_result;

    // Generate the AND operation once
    assign and_result = a & b;

    // Drive out_assign directly from the intermediate wire
    assign out_assign = and_result;

    // Drive out_alwaysblock from the intermediate wire inside always block
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule