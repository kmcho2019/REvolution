module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Internal wire to hold AND result once
    wire and_result;
    assign and_result = a & b;

    // Drive out_assign by assign statement
    assign out_assign = and_result;

    // Drive out_alwaysblock by combinational always block
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule