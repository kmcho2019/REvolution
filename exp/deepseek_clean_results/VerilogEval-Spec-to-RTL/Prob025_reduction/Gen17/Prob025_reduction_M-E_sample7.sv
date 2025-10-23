module TopModule (
    input [7:0] in,
    output reg parity
);
    // Intermediate parity calculations
    wire parity_lower = ^in[3:0];  // Lower nibble parity
    wire parity_upper = ^in[7:4];  // Upper nibble parity
    
    // Final parity calculation (could be registered for pipelining)
    always @(*) begin
        parity = parity_lower ^ parity_upper;
    end
    
    /* Pipelined version would look like:
    reg stage1_parity_lower, stage1_parity_upper;
    reg stage2_parity;
    
    always @(posedge clk) begin
        // Stage 1: Calculate nibble parities
        stage1_parity_lower <= ^in[3:0];
        stage1_parity_upper <= ^in[7:4];
        
        // Stage 2: Combine parities
        stage2_parity <= stage1_parity_lower ^ stage1_parity_upper;
    end
    assign parity = stage2_parity;
    */
endmodule