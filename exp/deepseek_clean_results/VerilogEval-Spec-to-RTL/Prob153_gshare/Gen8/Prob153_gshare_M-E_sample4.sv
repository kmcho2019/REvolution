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

    // Main Pattern History Table (128 entries)
    reg [1:0] pht [0:127];
    // Shadow PHT for misprediction recovery
    reg [1:0] shadow_pht [0:127];
    
    // Segmented Global History Register
    reg [2:0] recent_ghr;  // 3 most recent branches
    reg [3:0] older_ghr;   // 4 older branches
    wire [6:0] ghr = {older_ghr, recent_ghr};
    
    // 8-entry prediction cache
    reg [6:0] pc_cache [0:7];
    reg [1:0] pred_cache [0:7];
    wire [2:0] cache_index = predict_pc[2:0];
    
    // Prediction path
    wire [6:0] predict_index = predict_pc ^ {older_ghr[3:1], recent_ghr, older_ghr[0]}; // Folded XOR
    wire cache_hit = (pc_cache[cache_index] == predict_pc);
    assign predict_taken = cache_hit ? pred_cache[cache_index][1] : pht[predict_index][1];
    assign predict_history = ghr;
    
    // Training path
    wire [6:0] train_index = train_pc ^ {train_history[6:4], train_history[2:0], train_history[3]}; // Folded XOR
    
    // Counter update function with hysteresis
    function [1:0] update_counter;
        input [1:0] current;
        input taken;
        begin
            update_counter = current + (taken ? (current[1] ? 0 : 1) : (current[1] ? -1 : 0));
        end
    endfunction
    
    // Speculative next state calculation
    reg [6:0] next_ghr;
    reg [1:0] next_pht [0:127];
    always @(*) begin
        // Default no change
        next_ghr = ghr;
        for (int i = 0; i < 128; i++) next_pht[i] = pht[i];
        
        // Handle training first (higher priority)
        if (train_valid) begin
            if (train_mispredicted) begin
                next_ghr = {train_history[5:0], train_taken};
                // Restore from shadow PHT
                for (int i = 0; i < 128; i++) next_pht[i] = shadow_pht[i];
            end
            next_pht[train_index] = update_counter(pht[train_index], train_taken);
        end
        
        // Then handle prediction (may be overridden by training)
        if (predict_valid && (!train_valid || !train_mispredicted)) begin
            next_ghr = {ghr[5:0], predict_taken};
            // Speculative PHT update
            next_pht[predict_index] = update_counter(pht[predict_index], predict_taken);
        end
    end
    
    // Update state
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize to weakly not-taken
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
                shadow_pht[i] <= 2'b01;
            end
            recent_ghr <= 3'b0;
            older_ghr <= 4'b0;
            for (i = 0; i < 8; i = i + 1) begin
                pc_cache[i] <= 7'b0;
                pred_cache[i] <= 2'b01;
            end
        end else begin
            // Update PHT and shadow
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= next_pht[i];
                // Shadow PHT tracks confirmed state
                if (train_valid && !train_mispredicted)
                    shadow_pht[i] <= next_pht[i];
            end
            
            // Update GHR segments
            {older_ghr, recent_ghr} <= next_ghr;
            
            // Update prediction cache
            if (predict_valid) begin
                pc_cache[cache_index] <= predict_pc;
                pred_cache[cache_index] <= pht[predict_index];
            end
        end
    end

endmodule