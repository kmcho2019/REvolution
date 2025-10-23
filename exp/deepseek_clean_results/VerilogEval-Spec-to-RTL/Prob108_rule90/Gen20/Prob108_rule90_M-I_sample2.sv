module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [511:0] intermediate_q;
    wire gated_clk;
    
    // Clock gating for power optimization
    assign gated_clk = clk & (~load);
    
    // First stage: Compute next state for all cells
    wire [511:0] next_q_stage1;
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin: rule90_stage1
            wire left = (i == 0) ? 1'b0 : data[i-1];
            wire right = (i == 511) ? 1'b0 : data[i+1];
            assign next_q_stage1[i] = left ^ right;
        end
    endgenerate
    
    // Second stage: Compute next state based on previous computation
    wire [511:0] next_q_stage2;
    generate
        for (i = 0; i < 512; i = i + 1) begin: rule90_stage2
            wire left = (i == 0) ? 1'b0 : intermediate_q[i-1];
            wire right = (i == 511) ? 1'b0 : intermediate_q[i+1];
            assign next_q_stage2[i] = left ^ right;
        end
    endgenerate
    
    // Pipeline stage 1 (always active)
    always @(posedge clk) begin
        if (load) begin
            intermediate_q <= data;
        end else begin
            intermediate_q <= next_q_stage1;
        end
    end
    
    // Pipeline stage 2 (clock gated)
    always @(posedge gated_clk) begin
        q <= next_q_stage2;
    end

endmodule