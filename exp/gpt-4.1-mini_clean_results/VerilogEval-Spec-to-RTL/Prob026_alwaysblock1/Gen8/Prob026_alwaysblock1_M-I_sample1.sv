module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Internal wire for shared AND result
    wire and_result = a & b;

    // Continuous assign implementing AND directly
    assign out_assign = and_result;

    // Combinational always block assigning the shared AND result
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule