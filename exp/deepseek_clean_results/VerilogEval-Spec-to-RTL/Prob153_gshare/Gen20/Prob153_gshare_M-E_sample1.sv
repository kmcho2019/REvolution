module TopModule (
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    // Dual PHT structure (main and shadow)
    reg [1:0] main_pht [0:127];
    reg [1:0] shadow_pht [0:127];
    
    // Global History Register with recovery buffer
    reg [6:0] ghr;
    reg [6:0] recovery_ghr;
    
    // Misprediction counter for dynamic threshold
    reg [2:0] mispred_count;
    wire dynamic_threshold = (mispred_count > 3'd4) ? 1'b1 : 1'b0;
    
    // Prediction outputs
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = predict_valid ? 
                         (main_pht[predict_index] > {1'b0, dynamic_threshold}) : 1'b0;
    assign predict_history = ghr;
    
    // Training index calculation
    wire [6:0] train_index = train_pc ^ train_history;
    
    // Clock gating signal
    wire pht_update_en = train_valid;
    
    // Sequential updates
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHTs to weakly taken (2'b01)
            for (i = 0; i < 128; i = i + 1) begin
                main_pht[i] <= 2'b01;
                shadow_pht[i] <= 2'b01;
            end
            ghr <= 7'b0;
            recovery_ghr <= 7'b0;
            mispred_count <= 3'b0;
        end else begin
            // Update misprediction counter
            if (train_valid && train_mispredicted)
                mispred_count <= mispred_count + 1;
            else if (mispred_count > 0)
                mispred_count <= mispred_count - 1;
            
            // Update PHTs if training (clock gated)
            if (pht_update_en) begin
                // Update main PHT
                if (main_pht[train_index] < 2'b11 && train_taken)
                    main_pht[train_index] <= main_pht[train_index] + 1;
                else if (main_pht[train_index] > 2'b00 && !train_taken)
                    main_pht[train_index] <= main_pht[train_index] - 1;
                
                // Speculative update to shadow PHT
                shadow_pht[train_index] <= main_pht[train_index];
                if (shadow_pht[train_index] < 2'b11 && train_taken)
                    shadow_pht[train_index] <= shadow_pht[train_index] + 1;
                else if (shadow_pht[train_index] > 2'b00 && !train_taken)
                    shadow_pht[train_index] <= shadow_pht[train_index] - 1;
            end
            
            // Handle GHR updates with priority
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
                recovery_ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
            
            // On misprediction, sync shadow PHT to main PHT
            if (train_valid && train_mispredicted) begin
                for (i = 0; i < 128; i = i + 1)
                    shadow_pht[i] <= main_pht[i];
            end
        end
    end

endmodule