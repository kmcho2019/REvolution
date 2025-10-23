module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Self-timed XOR using delay-insensitive approach
    assign out_assign = (a & ~b) | (~a & b);

    // LUT-style implementation
    always @(*) begin
        case ({a,b})
            2'b00: out_always_comb = 1'b0;
            2'b01: out_always_comb = 1'b1;
            2'b10: out_always_comb = 1'b1;
            2'b11: out_always_comb = 1'b0;
            default: out_always_comb = 1'b0;
        endcase
    end

    // Pipelined sequential version with clock gating
    reg stage1, stage2;
    wire clk_enable = (a ^ b) != stage2;  // Only clock when input changes
    
    always @(posedge clk) begin
        if (clk_enable) begin
            stage1 <= a ^ b;      // First synchronization stage
            stage2 <= stage1;      // Second synchronization stage
        end
    end

    assign out_always_ff = stage2;

endmodule