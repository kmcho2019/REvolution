module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    assign out_assign = a & b; // Continuous assignment with direct AND

    always @(*) begin
        out_alwaysblock = a & b; // Combinational always block computing AND directly
    end

endmodule