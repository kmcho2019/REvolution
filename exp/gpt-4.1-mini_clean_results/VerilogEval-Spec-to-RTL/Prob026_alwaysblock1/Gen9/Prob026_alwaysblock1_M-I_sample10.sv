module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Shared internal wire for AND computation
    wire and_result;
    assign and_result = a & b;

    // Continuous assign drives one output
    assign out_assign = and_result;

    // Combinational always block drives the other output using shared wire
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule