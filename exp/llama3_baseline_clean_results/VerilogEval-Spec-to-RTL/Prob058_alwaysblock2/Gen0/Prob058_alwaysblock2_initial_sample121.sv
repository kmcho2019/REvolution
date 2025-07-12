module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output logic out_always_ff
);

// Using assign statement
assign out_assign = a ^ b;

// Using always_comb block
always_comb begin
    out_always_comb = a ^ b;
end

// Using always_ff block
always_ff @(posedge clk) begin
    out_always_ff <= a ^ b;
end

endmodule