module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Continuous assignment directly computes XOR
    assign out_assign = a ^ b;

    // Combinational always block computes XOR directly
    always @(*) begin
        out_always_comb = a ^ b;  // Blocking assignment for combinational logic
    end

    // Sequential always block registers XOR computed on clock edge
    always @(posedge clk) begin
        out_always_ff <= a ^ b;   // Non-blocking assignment for sequential logic
    end

endmodule