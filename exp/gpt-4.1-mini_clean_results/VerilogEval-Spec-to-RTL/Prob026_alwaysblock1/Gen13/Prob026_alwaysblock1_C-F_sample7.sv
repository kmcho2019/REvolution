module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Internal wire to hold the AND result for logic sharing
    wire and_result;
    assign and_result = a & b;

    // Continuous assign drives out_assign directly from internal wire
    assign out_assign = and_result;

    // Combinational always block drives out_alwaysblock from same wire
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule