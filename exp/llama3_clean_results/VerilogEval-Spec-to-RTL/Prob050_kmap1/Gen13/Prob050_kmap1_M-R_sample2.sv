module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Using an always_comb block for combinational logic
always_comb begin
    out = a | b | c;
end

endmodule