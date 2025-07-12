module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff
);

    reg a_prev;

    // Standard combinational XOR outputs
    assign out_assign = a ^ b;
    assign out_always_comb = a ^ b;

    // Sequential logic with temporal behavior
    always @(posedge clk) begin
        a_prev <= a;
        out_always_ff <= a ^ a_prev ^ b;
    end

endmodule