module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

// Function to compute XOR of a and b
function automatic logic xor_func(input logic x, input logic y);
    xor_func = x ^ y;
endfunction

assign out_assign = xor_func(a, b);

always @(*) begin
    out_always_comb = xor_func(a, b);
end

always @(posedge clk) begin
    out_always_ff <= xor_func(a, b);
end

endmodule