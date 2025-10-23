module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff
);

    // Continuous assignment - most efficient XOR implementation
    assign out_assign = a ^ b;

    // Combinational implementation using direct XOR (more efficient than ternary)
    assign out_always_comb = a ^ b;

    // Sequential implementation (required for delayed output)
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule