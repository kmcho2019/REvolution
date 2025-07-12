module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Compute the AND once, share it with both outputs
    wire and_result = a & b;

    // Continuous assign output
    assign out_assign = and_result;

    // Combinational always block output
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule