module TopModule (
    input a,
    input b,
    input c,
    input d,
    output reg out,
    output out_n
);

    // Internal wires
    wire and1_out, and2_out;

    // Combinational logic in always block
    always @(*) begin
        and1_out = a & b;
        and2_out = c & d;
        out = and1_out | and2_out;
    end

    // Inverted output remains continuous assignment
    assign out_n = ~out;

endmodule