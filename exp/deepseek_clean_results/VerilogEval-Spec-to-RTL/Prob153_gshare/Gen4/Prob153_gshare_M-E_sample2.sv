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

    // Main PHT and shadow PHT (updated one cycle later)
    reg [1:0] pht [0:127];
    reg [1:0] shadow_pht [0:127];
    
    // Dual GHR system
    reg [6:0] speculative_ghr;
    reg [6:0] committed_ghr;
    
    // Prediction index (combinational)
    wire [6:0] predict_index = predict_pc ^ speculative_ghr;
    
    // Training index (combinational)
    wire [6:0] train_index = train_pc ^ (train_mispredicted ? train_history : committed_ghr);
    
    // PHT update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize both PHTs to weakly not-taken
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
                shadow_pht[i] <= 2'b01;
            end
            speculative_ghr <= 7'b0;
            committed_ghr <= 7'b0;
        end else begin
            // Update shadow PHT (always one cycle behind)
            for (integer i = 0; i < 128; i = i + 1)
                shadow_pht[i] <= pht[i];
            
            // Training has absolute priority
            if (train_valid) begin
                // Update PHT counter (saturating)
                if (train_taken)
                    pht[train_index] <= (pht[train_index] == 2'b11) ? 2'b11 : pht[train_index] + 1;
                else
                    pht[train_index] <= (pht[train_index] == 2'b00) ? 2'b00 : pht[train_index] - 1;
                
                // Update GHRs
                if (train_mispredicted) begin
                    // Recovery path
                    speculative_ghr <= {train_history[5:0], train_taken};
                    committed_ghr <= {train_history[5:0], train_taken};
                end else begin
                    // Normal training update
                    speculative_ghr <= {committed_ghr[5:0], train_taken};
                    committed_ghr <= {committed_ghr[5:0], train_taken};
                end
            end
            else if (predict_valid) begin
                // Only update speculative GHR if not training
                speculative_ghr <= {speculative_ghr[5:0], shadow_pht[predict_index][1]};
            end
        end
    end

    // Prediction output (combinational)
    always @(*) begin
        if (predict_valid) begin
            predict_taken = shadow_pht[predict_index][1];
            predict_history = speculative_ghr;
        end else begin
            predict_taken = 1'b0;
            predict_history = 7'b0;
        end
    end

endmodule