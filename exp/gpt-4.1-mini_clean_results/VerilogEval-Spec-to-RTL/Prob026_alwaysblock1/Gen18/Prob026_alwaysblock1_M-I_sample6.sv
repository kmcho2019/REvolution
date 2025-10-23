module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Shared wire for AND operation to reduce duplicate logic
    wire and_result;
    assign and_result = a & b;

    // Continuous assign output from shared wire
    assign out_assign = and_result;

    // Combinational always block output from shared wire
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule