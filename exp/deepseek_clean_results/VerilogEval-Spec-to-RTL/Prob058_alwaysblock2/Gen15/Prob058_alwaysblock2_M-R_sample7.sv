module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Method 1: Continuous assignment (simplest form)
    assign out_assign = a ^ b;

    // Method 2: Combinational always block (SystemVerilog style)
    always_comb begin
        out_always_comb = a ^ b;
    end

    // Method 3: Sequential implementation with flip-flop
    always @(posedge clk) begin
        // Output updates only on clock edges
        out_always_ff <= a ^ b;
    end

endmodule