module TopModule(
    input  wire a,
    input  wire b,
    output logic out
);

always_comb begin
    out = a & b;
end

endmodule