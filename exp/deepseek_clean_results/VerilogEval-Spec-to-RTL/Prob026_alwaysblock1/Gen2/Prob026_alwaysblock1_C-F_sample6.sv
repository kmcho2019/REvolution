module TopModule (
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);

    // Common AND logic
    wire and_result = a & b;

    // Implementation using assign statement
    assign out_assign = and_result;

    // Implementation using always block
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule