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

    // Architectural GHR (confirmed branches)
    reg [6:0] arch_ghr;
    // Speculative GHR (predicted branches)
    reg [6:0] spec_ghr;
    // 128-entry pattern history table
    reg [1:0] pht [0:127];
    
    // Current effective GHR (speculative unless training)
    wire [6:0] current_ghr = (train_valid && train_mispredicted) ? train_history : 
                            predict_valid ? spec_ghr : arch_ghr;
    
    // Prediction logic
    wire [6:0] predict_index = predict_pc ^ current_ghr;
    assign predict_taken = predict_valid ? pht[predict_index][1] : 1'b0;
    assign predict_history = current_ghr;
    
    // Training index
    wire [6:0] train_index = train_pc ^ train_history;
    
    // Next state calculation for PHT
    wire [1:0] next_pht_state;
    assign next_pht_state = 
        (pht[train_index] == 2'b00) ? (train_taken ? 2'b01 : 2'b00) :
        (pht[train_index] == 2'b01) ? (train_taken ? 2'b10 : 2'b00) :
        (pht[train_index] == 2'b10) ? (train_taken ? 2'b11 : 2'b01) :
                                      (train_taken ? 2'b11 : 2'b10);
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            arch_ghr <= 7'b0;
            spec_ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;  // Weakly not-taken
        end else begin
            // PHT update
            if (train_valid)
                pht[train_index] <= next_pht_state;
            
            // GHR updates
            if (train_valid) begin
                // Always update architectural GHR during training
                arch_ghr <= {train_history[5:0], train_taken};
                
                // On misprediction, reset speculative GHR
                if (train_mispredicted)
                    spec_ghr <= {train_history[5:0], train_taken};
            end
            
            // Speculative GHR update (only if no training misprediction)
            if (predict_valid && !(train_valid && train_mispredicted))
                spec_ghr <= {current_ghr[5:0], predict_taken};
        end
    end

endmodule