module TopModule(
    input  logic a,
    input  logic b,
    input  logic cin,
    output logic cout,
    output logic sum
);

always_comb begin
    sum = a ^ b ^ cin;
    cout = (a & b) | (a & cin) | (b & cin);
end

endmodule