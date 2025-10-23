module TopModule (
    input clk,
    input a,
    input b,
    output wire out_assign,
    output wire out_always_comb,
    output reg out_always_ff
);

    // Continuous assignment style (direct XOR)
    assign out_assign = a ^ b;
    
    // Alternative combinational style using ternary operator
    assign out_always_comb = (a == b) ? 1'b0 : 1'b1;
    
    // Sequential always block with initialization
    initial out_always_ff = 1'b0;
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule