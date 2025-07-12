module TopModule (
    input wire clk,
    input wire a,
    input wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg out_always_ff
);

    // All combinational outputs use direct XOR for maximum efficiency
    assign out_assign = a ^ b;
    assign out_always_comb = a ^ b;
    
    // Sequential output with explicit clocking
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule