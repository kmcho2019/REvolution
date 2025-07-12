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

    // Architectural and speculative GHRs
    reg [6:0] arch_ghr;
    reg [6:0] spec_ghr;
    
    // PHT with write buffer
    reg [1:0] pht [0:127];
    reg [6:0] pht_wb_index;
    reg [1:0] pht_wb_data;
    reg pht_wb_valid;
    
    // Prediction logic
    wire [6:0] predict_index = predict_pc ^ spec_ghr;
    assign predict_taken = pht[predict_index][1];
    assign predict_history = spec_ghr;
    
    // Training index
    wire [6:0] train_index = train_pc ^ train_history;
    
    // Next GHR state
    wire [6:0] next_ghr = {arch_ghr[5:0], train_taken};
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset all state
            arch_ghr <= 7'b0;
            spec_ghr <= 7'b0;
            pht_wb_valid <= 1'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
        end else begin
            // Commit buffered PHT writes
            if (pht_wb_valid) begin
                pht[pht_wb_index] <= pht_wb_data;
                pht_wb_valid <= 1'b0;
            end
            
            // Handle training (higher priority)
            if (train_valid) begin
                // Buffer PHT update
                pht_wb_index <= train_index;
                if (train_taken) begin
                    pht_wb_data <= (pht[train_index] == 2'b11) ? 2'b11 : pht[train_index] + 1;
                end else begin
                    pht_wb_data <= (pht[train_index] == 2'b00) ? 2'b00 : pht[train_index] - 1;
                end
                pht_wb_valid <= 1'b1;
                
                // Update architectural GHR on misprediction
                if (train_mispredicted) begin
                    arch_ghr <= next_ghr;
                    spec_ghr <= next_ghr;
                end
            end
            
            // Handle prediction
            if (predict_valid) begin
                // Speculatively update GHR
                spec_ghr <= {spec_ghr[5:0], predict_taken};
                
                // Only update architectural GHR if no training conflict
                if (!train_valid || !train_mispredicted) begin
                    arch_ghr <= {arch_ghr[5:0], predict_taken};
                end
            end
        end
    end

endmodule