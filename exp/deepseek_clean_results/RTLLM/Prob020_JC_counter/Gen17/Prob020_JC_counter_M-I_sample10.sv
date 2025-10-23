module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [31:0] Q_upper;
reg [31:0] Q_lower;
wire all_ones = &Q;
wire all_zeros = ~|Q;
wire clock_enable = !(all_ones || all_zeros);

// Clock gating control
// synopsys translate_off
// Enable power optimization through clock gating
// synopsys translate_on

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        Q_upper <= 32'b0;
        Q_lower <= 32'b0;
    end
    else if (clock_enable) begin
        // First pipeline stage - process lower 32 bits
        Q_lower <= {~Q[0], Q[31:1]};
        
        // Second pipeline stage - process upper 32 bits
        Q_upper <= {Q[32], Q[63:33]};
        
        // Combine results
        Q <= {Q_upper, Q_lower};
    end
end

endmodule