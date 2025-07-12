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

    // 7-bit global history register with pipeline stage
    reg [6:0] ghr, ghr_next;
    // 128-entry pattern history table (2-bit saturating counters)
    reg [1:0] pht [0:127];
    reg pht_update_en;
    
    // Shared XOR terms
    wire [6:0] predict_xor = predict_pc ^ ghr;
    wire [6:0] train_xor = train_pc ^ train_history;
    
    // Pre-compute next PHT states
    wire [1:0] pht_inc = (pht[train_xor] == 2'b11) ? 2'b11 : (pht[train_xor] + 1);
    wire [1:0] pht_dec = (pht[train_xor] == 2'b00) ? 2'b00 : (pht[train_xor] - 1);
    
    // Clock gating for PHT
    assign pht_update_en = train_valid && !areset;
    
    // Prediction is registered for better timing
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
        end else if (predict_valid) begin
            predict_taken <= pht[predict_xor][1];
            predict_history <= ghr;
        end
    end
    
    // Update PHT and GHR
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT
            ghr <= 7'b0;
            ghr_next <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // PHT update with clock gating
            if (pht_update_en) begin
                pht[train_xor] <= train_taken ? pht_inc : pht_dec;
            end
            
            // Pipeline GHR updates
            ghr <= ghr_next;
            
            // GHR next state logic
            if (train_valid && train_mispredicted) begin
                ghr_next <= {train_history[5:0], train_taken};
            end else if (predict_valid) begin
                ghr_next <= {ghr[5:0], pht[predict_xor][1]};
            end
        end
    end

endmodule