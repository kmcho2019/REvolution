module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // Parameterized Logic Cell module
    module LogicCell #(
        parameter TYPE = 0  // 0:AND, 1:OR, 2:NOT
    ) (
        input in0,
        input in1,
        output out
    );
        generate
            if (TYPE == 0) assign out = in0 & in1;  // AND
            else if (TYPE == 1) assign out = in0 | in1;  // OR
            else assign out = ~in0;  // NOT (in1 unused)
        endgenerate
    endmodule

    // First layer AND gates
    wire and_ab, and_cd;
    LogicCell #(.TYPE(0)) and1 (.in0(a), .in1(b), .out(and_ab));
    LogicCell #(.TYPE(0)) and2 (.in0(c), .in1(d), .out(and_cd));

    // Second layer OR gate
    LogicCell #(.TYPE(1)) or1 (.in0(and_ab), .in1(and_cd), .out(out));

    // Inverted output (using same LogicCell)
    LogicCell #(.TYPE(2)) inv1 (.in0(out), .in1(1'b0), .out(out_n));

endmodule