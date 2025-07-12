module TopModule (
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output reg predict_taken,
    output reg [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    // 7-bit global history register
    reg [6:0] ghr;
    // 128-entry pattern history table (2-bit saturating counters)
    reg [1:0] pht [0:127];
    
    // Clock gating signals
    wire pht_access = predict_valid | train_valid;
    wire clk_gated = clk & pht_access;
    
    // Pipelined index calculation
    reg [6:0] predict_index_reg;
    reg [6:0] train_index_reg;
    wire [6:0] index_xor = predict_valid ? (predict_pc ^ ghr) : (train_pc ^ train_history);
    
    // Simplified counter update logic
    wire [1:0] new_counter_state;
    assign new_counter_state = pht[train_index_reg] + 
                             (train_taken ? 2'b01 : -2'b01);
    
    // Prediction output registers
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            predict_taken <= predict_valid ? pht[predict_index_reg][1] : 1'b0;
            predict_history <= ghr;
        end
    end
    
    // Main sequential logic
    always @(posedge clk_gated or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // Register indices
            predict_index_reg <= predict_valid ? index_xor : predict_index_reg;
            train_index_reg <= train_valid ? index_xor : train_index_reg;
            
            // PHT update (simplified arithmetic)
            if (train_valid) begin
                pht[train_index_reg] <= (train_taken && (pht[train_index_reg] != 2'b11)) ? 
                                       pht[train_index_reg] + 1 :
                                       (!train_taken && (pht[train_index_reg] != 2'b00)) ? 
                                       pht[train_index_reg] - 1 :
                                       pht[train_index_reg];
            end
        end
    end
    
    // GHR update (separate always block for clarity)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
        end else begin
            // Training has priority
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid && !(train_valid && train_mispredicted)) begin
                ghr <= {ghr[5:0], pht[predict_index_reg][1]};
            end
        end
    end

endmodule