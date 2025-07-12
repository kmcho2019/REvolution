module TopModule #(
    parameter DELAY_STAGES = 1
) (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output out_always_ff
);

    // Continuous assignment remains simplest
    assign out_assign = a ^ b;

    // Combinational always block
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Sequential implementation with configurable delay
    reg [DELAY_STAGES:0] delay_chain;
    
    always @(posedge clk) begin
        delay_chain[0] <= a ^ b;
        for (int i = 1; i <= DELAY_STAGES; i++) begin
            delay_chain[i] <= delay_chain[i-1];
        end
    end

    assign out_always_ff = delay_chain[DELAY_STAGES];

endmodule