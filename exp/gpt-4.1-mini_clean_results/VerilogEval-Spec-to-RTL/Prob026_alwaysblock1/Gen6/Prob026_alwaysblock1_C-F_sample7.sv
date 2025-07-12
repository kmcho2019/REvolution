module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Internal wire for AND computation
    wire and_result = a & b;

    // Continuous assignment using the computed wire
    assign out_assign = and_result;

    // Combinational always block driven by the same internal wire
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule