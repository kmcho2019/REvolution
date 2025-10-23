module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Internal signal to hold AND result
    wire and_result;

    // Combinational always block with blocking assignment computing AND once
    always @(*) begin
        out_alwaysblock = a & b;
    end

    // Continuous assign driven from the always block result (same logic)
    assign out_assign = out_alwaysblock;

endmodule