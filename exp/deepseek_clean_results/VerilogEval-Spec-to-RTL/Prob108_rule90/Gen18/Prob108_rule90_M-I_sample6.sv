module TopModule (
    input clk,
    input load,
    input stall,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [511:0] stage1, stage2, stage3;
    wire [511:0] next_q;
    reg load_delay;
    
    // Clock gating control
    wire update_en = load | ~stall;
    wire clk_en = update_en | load_delay;
    
    // Boundary handling through concatenation
    wire [511:0] left_neighbors = {1'b0, q[511:1]};
    wire [511:0] right_neighbors = {q[510:0], 1'b0};
    
    // Pipeline stage 1: Compute first 128 bits
    always @(posedge clk) begin
        if (clk_en) begin
            stage1[127:0] <= left_neighbors[127:0] ^ right_neighbors[127:0];
        end
    end
    
    // Pipeline stage 2: Compute next 128 bits and register stage1
    always @(posedge clk) begin
        if (clk_en) begin
            stage1[255:128] <= left_neighbors[255:128] ^ right_neighbors[255:128];
            stage2[127:0] <= stage1[127:0];
        end
    end
    
    // Pipeline stage 3: Compute next 128 bits and register previous stages
    always @(posedge clk) begin
        if (clk_en) begin
            stage1[383:256] <= left_neighbors[383:256] ^ right_neighbors[383:256];
            stage2[255:128] <= stage1[255:128];
            stage3[127:0] <= stage2[127:0];
        end
    end
    
    // Pipeline stage 4: Compute final 128 bits and register previous stages
    always @(posedge clk) begin
        if (clk_en) begin
            stage1[511:384] <= left_neighbors[511:384] ^ right_neighbors[511:384];
            stage2[383:256] <= stage1[383:256];
            stage3[255:128] <= stage2[255:128];
        end
    end
    
    // Final output assembly
    assign next_q = {stage1[511:384], stage2[383:256], stage3[255:128], stage3[127:0]};
    
    // Load delay for proper pipeline flushing
    always @(posedge clk) begin
        load_delay <= load;
    end
    
    // Main state update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (update_en) begin
            q <= next_q;
        end
    end

endmodule