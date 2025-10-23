module TopModule (
    input clk,
    input a,
    input b,
    output wire out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    parameter DELAY_CYCLES = 1;  // Configurable delay depth
    
    // Baseline continuous assignment
    assign out_assign = a ^ b;
    
    // Combinational with potential for additional logic
    always @(*) begin
        out_always_comb = a ^ b;  // Could add other logic here
    end
    
    // Sequential with configurable delay pipeline
    reg [DELAY_CYCLES-1:0] delay_chain;
    
    always @(posedge clk) begin
        if (DELAY_CYCLES > 1) begin
            delay_chain <= {delay_chain[DELAY_CYCLES-2:0], a ^ b};
            out_always_ff <= delay_chain[DELAY_CYCLES-1];
        end else begin
            out_always_ff <= a ^ b;  // Single cycle delay
        end
    end

endmodule