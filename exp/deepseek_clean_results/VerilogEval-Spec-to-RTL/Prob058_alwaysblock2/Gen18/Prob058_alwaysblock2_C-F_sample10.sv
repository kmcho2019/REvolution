module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Method 1: Continuous assignment - simplest implementation
    assign out_assign = a ^ b;

    // Method 2: Combinational logic - modern SystemVerilog style
    always_comb begin
        out_always_comb = a ^ b;
    end

    // Method 3: Sequential logic - edge-triggered flip-flop
    always @(posedge clk) begin
        out_always_ff <= a ^ b;  // Output updates on clock edges
    end

endmodule