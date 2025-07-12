module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output logic out_always_ff // Initialize output variable to avoid warning
);

assign out_assign = a ^ b;

always_comb begin
    out_always_comb = a ^ b;
end

always_ff @(posedge clk) begin
    out_always_ff <= a ^ b;
end

endmodule