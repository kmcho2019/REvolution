module TopModule (
    input clk,
    input a,
    input b,
    output wire out_assign,
    output wire out_always_comb,
    output reg out_always_ff
);

    // Combinational logic using assign statements
    assign out_assign = a ^ b;
    assign out_always_comb = a ^ b;
    
    // Sequential logic with clocked always block
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule