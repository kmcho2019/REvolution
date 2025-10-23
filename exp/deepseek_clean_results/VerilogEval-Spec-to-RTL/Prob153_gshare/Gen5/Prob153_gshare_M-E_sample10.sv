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

    // Dual GHR implementation (main and shadow)
    reg [6:0] ghr_main, ghr_shadow;
    // Banked PHT structure (even and odd banks)
    reg [1:0] pht_even [0:63];
    reg [1:0] pht_odd [0:63];
    // Secondary PHT for GHR patterns
    reg [1:0] s_pht [0:127];
    
    // Prediction indices
    wire [6:0] predict_index = predict_pc ^ ghr_main;
    wire predict_bank = predict_index[0];
    wire [6:0] s_predict_index = ghr_main;
    
    // Prediction results
    wire pht_pred = predict_bank ? pht_odd[predict_index[6:1]][1] : pht_even[predict_index[6:1]][1];
    wire s_pht_pred = s_pht[s_predict_index][1];
    assign predict_taken = predict_valid ? (pht_pred & s_pht_pred) : 1'b0;
    assign predict_history = ghr_main;
    
    // Training indices
    wire [6:0] train_index = train_pc ^ train_history;
    wire train_bank = train_index[0];
    wire [6:0] s_train_index = train_history;
    
    // Speculative GHR update
    wire [6:0] next_ghr = {ghr_main[5:0], predict_taken};
    
    // Update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr_main <= 7'b0;
            ghr_shadow <= 7'b0;
            for (integer i = 0; i < 64; i = i + 1) begin
                pht_even[i] <= 2'b01;
                pht_odd[i] <= 2'b01;
            end
            for (integer i = 0; i < 128; i = i + 1) begin
                s_pht[i] <= 2'b01;
            end
        end else begin
            // Update GHR - speculative during predict, confirmed during train
            if (predict_valid) begin
                ghr_main <= next_ghr;
                ghr_shadow <= next_ghr;
            end
            
            // Handle mispredictions (recover GHR)
            if (train_valid && train_mispredicted) begin
                ghr_main <= {train_history[5:0], train_taken};
            end
            
            // Primary PHT training
            if (train_valid) begin
                if (train_bank) begin
                    case (pht_odd[train_index[6:1]])
                        2'b00: pht_odd[train_index[6:1]] <= train_taken ? 2'b01 : 2'b00;
                        2'b01: pht_odd[train_index[6:1]] <= train_taken ? 2'b10 : 2'b00;
                        2'b10: pht_odd[train_index[6:1]] <= train_taken ? 2'b11 : 2'b01;
                        2'b11: pht_odd[train_index[6:1]] <= train_taken ? 2'b11 : 2'b10;
                    endcase
                end else begin
                    case (pht_even[train_index[6:1]])
                        2'b00: pht_even[train_index[6:1]] <= train_taken ? 2'b01 : 2'b00;
                        2'b01: pht_even[train_index[6:1]] <= train_taken ? 2'b10 : 2'b00;
                        2'b10: pht_even[train_index[6:1]] <= train_taken ? 2'b11 : 2'b01;
                        2'b11: pht_even[train_index[6:1]] <= train_taken ? 2'b11 : 2'b10;
                    endcase
                end
                
                // Secondary PHT training
                case (s_pht[s_train_index])
                    2'b00: s_pht[s_train_index] <= train_taken ? 2'b01 : 2'b00;
                    2'b01: s_pht[s_train_index] <= train_taken ? 2'b10 : 2'b00;
                    2'b10: s_pht[s_train_index] <= train_taken ? 2'b11 : 2'b01;
                    2'b11: s_pht[s_train_index] <= train_taken ? 2'b11 : 2'b10;
                endcase
            end
            
            // Early training for predictions
            if (predict_valid && !train_valid) begin
                if (predict_bank) begin
                    pht_odd[predict_index[6:1]] <= pht_odd[predict_index[6:1]] + (predict_taken ? 1 : -1);
                end else begin
                    pht_even[predict_index[6:1]] <= pht_even[predict_index[6:1]] + (predict_taken ? 1 : -1);
                end
                s_pht[s_predict_index] <= s_pht[s_predict_index] + (predict_taken ? 1 : -1);
            end
        end
    end

endmodule