module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Internal wire to hold single AND computation
    wire and_result;
    assign and_result = a & b;

    // Assign output directly from the internal wire
    assign out_assign = and_result;

    // Combinational always block assigns from the same wire to avoid recomputation
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule