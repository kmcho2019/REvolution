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

    // 7-bit global history register with clock gating
    reg [6:0] ghr;
    wire ghr_update_en = predict_valid || (train_valid && train_mispredicted);
    
    // 128-entry pattern history table with lazy initialization
    reg [1:0] pht [0:127];
    reg [127:0] pht_initialized = 128'b0;
    
    // Registered indices to break critical path
    reg [6:0] predict_index_reg;
    reg [6:0] train_index_reg;
    
    // Prediction logic with registered index
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index_reg][1];
    assign predict_history = ghr;
    
    // Training index calculation
    wire [6:0] train_index = train_pc ^ train_history;
    
    // PHT update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            predict_index_reg <= 7'b0;
            train_index_reg <= 7'b0;
            pht_initialized <= 128'b0;
        end else begin
            // Register indices
            predict_index_reg <= predict_index;
            if (train_valid) begin
                train_index_reg <= train_index;
            end
            
            // Lazy PHT initialization
            if (predict_valid && !pht_initialized[predict_index]) begin
                pht[predict_index] <= 2'b01;
                pht_initialized[predict_index] <= 1'b1;
            end
            if (train_valid && !pht_initialized[train_index]) begin
                pht[train_index] <= 2'b01;
                pht_initialized[train_index] <= 1'b1;
            end
            
            // GHR update with clock gating
            if (ghr_update_en) begin
                if (train_valid && train_mispredicted) begin
                    ghr <= {train_history[5:0], train_taken};
                end else if (predict_valid) begin
                    ghr <= {ghr[5:0], predict_taken};
                end
            end
        end
    end
    
    // PHT update logic (separate always block for timing)
    always @(posedge clk) begin
        if (train_valid) begin
            // Update PHT counter only when training
            if (train_taken) begin
                pht[train_index_reg] <= (pht[train_index_reg] == 2'b11) ? 
                                        2'b11 : pht[train_index_reg] + 1;
            end else begin
                pht[train_index_reg] <= (pht[train_index_reg] == 2'b00) ? 
                                        2'b00 : pht[train_index_reg] - 1;
            end
        end
    end

endmodule