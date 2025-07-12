module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Single wire computing XOR once
    wire xor_val = a ^ b;

    // Assign output combinationally
    assign out_assign = xor_val;

    // Combinational always block driven by the same wire
    always @(*) begin
        out_always_comb = xor_val;
    end

    // Sequential always block registering the XOR value on posedge clk
    always @(posedge clk) begin
        out_always_ff <= xor_val;
    end

endmodule