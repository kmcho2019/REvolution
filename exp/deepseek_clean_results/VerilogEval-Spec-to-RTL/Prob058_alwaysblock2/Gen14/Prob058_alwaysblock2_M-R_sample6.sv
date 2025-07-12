module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // 1. Continuous assignment (unchanged)
    assign out_assign = a ^ b;
    
    // 2. Combinational always block (changed from wire)
    always_comb begin
        out_always_comb = a ^ b;
    end
    
    // 3. Sequential always block (register moved to port)
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule