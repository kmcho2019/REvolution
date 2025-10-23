module TopModule (
    input clk,
    input a,
    input b,
    output wire out_assign,
    output wire out_always_comb,
    output reg out_always_seq
);

    // Both combinational outputs use direct assign
    assign out_assign = a ^ b;
    assign out_always_comb = a ^ b;
    
    // Sequential output with explicit naming
    always @(posedge clk) begin
        out_always_seq <= a ^ b;
    end

endmodule