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

    // Segmented GHR: [3-bit recent][4-bit older]
    reg [2:0] ghr_recent;
    reg [3:0] ghr_older;
    assign predict_history = {ghr_recent, ghr_older};

    // Dual-ported PHT (128 entries x 2 bits)
    reg [1:0] pht [0:127];
    reg [1:0] shadow_pht [0:127]; // For speculative updates

    // Confidence counters (1 bit per entry)
    reg confidence [0:127];

    // Prediction logic
    wire [6:0] predict_index = predict_pc ^ {ghr_recent, ghr_older};
    assign predict_taken = pht[predict_index][1];

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;

    // Update tracking
    reg [6:0] last_predict_index;
    reg last_predict_taken;
    reg prediction_pending;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize all state
            ghr_recent <= 3'b0;
            ghr_older <= 4'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
                shadow_pht[i] <= 2'b01;
                confidence[i] <= 1'b0;
            end
            prediction_pending <= 1'b0;
        end else begin
            // Phase 1: Handle training (highest priority)
            if (train_valid) begin
                // Update actual PHT
                if (train_taken) begin
                    pht[train_index] <= (pht[train_index] == 2'b11) ? 2'b11 : pht[train_index] + 1;
                end else begin
                    pht[train_index] <= (pht[train_index] == 2'b00) ? 2'b00 : pht[train_index] - 1;
                end
                
                // Update confidence
                confidence[train_index] <= (pht[train_index][1] == train_taken);
                
                // On misprediction, recover GHR and rollback speculative updates
                if (train_mispredicted) begin
                    ghr_recent <= train_history[6:4];
                    ghr_older <= train_history[3:0];
                    // Rollback speculative updates
                    for (integer i = 0; i < 128; i = i + 1) begin
                        shadow_pht[i] <= pht[i];
                    end
                end
            end
            
            // Phase 2: Handle predictions and speculative updates
            if (predict_valid && (!train_valid || !train_mispredicted)) begin
                // Speculative PHT update based on prediction
                if (confidence[predict_index]) begin
                    if (predict_taken) begin
                        shadow_pht[predict_index] <= (shadow_pht[predict_index] == 2'b11) ? 
                                                    2'b11 : shadow_pht[predict_index] + 1;
                    end else begin
                        shadow_pht[predict_index] <= (shadow_pht[predict_index] == 2'b00) ? 
                                                    2'b00 : shadow_pht[predict_index] - 1;
                    end
                end
                
                // Update GHR segments (recent history shifts out to older)
                ghr_older <= {ghr_older[2:0], ghr_recent[2]};
                ghr_recent <= {ghr_recent[1:0], predict_taken};
                
                // Track pending updates
                last_predict_index <= predict_index;
                last_predict_taken <= predict_taken;
                prediction_pending <= 1'b1;
            end else if (prediction_pending) begin
                // Commit speculative updates if no misprediction occurred
                pht[last_predict_index] <= shadow_pht[last_predict_index];
                prediction_pending <= 1'b0;
            end
        end
    end

endmodule