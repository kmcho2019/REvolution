module TopModule (
    input clk,
    input a,
    input b,
    output wire out_assign,
    output wire out_always_comb,
    output reg out_always_ff
);

    // All combinational logic using assign
    assign out_assign = a ^ b;
    assign out_always_comb = a ^ b;
    
    // Sequential logic only
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule