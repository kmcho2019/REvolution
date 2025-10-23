module TopModule (
    input in1,
    input in2,
    output out
);
    (* optimize_power *)
    (* optimize_area *)
    NOR2X1 nor_gate (
        .A(in1),
        .B(in2),
        .Y(out)
    );
endmodule