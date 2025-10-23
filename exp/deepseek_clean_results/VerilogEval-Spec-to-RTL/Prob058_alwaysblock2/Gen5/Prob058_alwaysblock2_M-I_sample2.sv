module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff
);

    // Continuous assignment for both combinational outputs
    assign out_assign = a ^ b;
    assign out_always_comb = out_assign;  // Directly use the same signal
    
    // Sequential implementation
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule