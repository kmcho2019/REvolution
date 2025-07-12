module ZeroDriver(
    output logic zero_out
);
    always_comb zero_out = 1'b0;
endmodule

module TopModule(
    output out
);
    ZeroDriver zd(.zero_out(out));
endmodule