module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Continuous assignment implementing XOR
    assign out_assign = a ^ b;

    // Combinational always block implementing XOR using always_comb
    always_comb begin
        out_always_comb = a ^ b;
    end

    // Sequential always_ff block with non-blocking assignment, output delayed by one clock cycle
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule