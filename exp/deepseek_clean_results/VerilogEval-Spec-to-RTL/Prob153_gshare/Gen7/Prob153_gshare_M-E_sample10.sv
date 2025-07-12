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

    // Segmented GHR: 4-bit speculative + 3-bit committed
    reg [3:0] speculative_ghr;
    reg [2:0] committed_ghr;
    
    // Combined history for output
    assign predict_history = {committed_ghr, speculative_ghr};
    
    // Dual PHT structure
    reg [1:0] speculative_pht [0:15];  // 16-entry (4-bit index)
    reg [1:0] committed_pht [0:127];   // 128-entry (7-bit index)

    // Prediction path
    wire [3:0] predict_index = predict_pc[3:0] ^ speculative_ghr;
    assign predict_taken = speculative_pht[predict_index][1];

    // Training path
    wire [6:0] train_index = train_pc ^ train_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset all state
            speculative_ghr <= 4'b0;
            committed_ghr <= 3'b0;
            
            // Initialize PHTs
            for (integer i = 0; i < 16; i = i + 1) begin
                speculative_pht[i] <= 2'b01;
            end
            for (integer j = 0; j < 128; j = j + 1) begin
                committed_pht[j] <= 2'b01;
            end
        end else begin
            // Training has highest priority
            if (train_valid) begin
                // Update committed PHT
                if (train_taken) begin
                    committed_pht[train_index] <= 
                        (committed_pht[train_index] == 2'b11) ? 
                        2'b11 : committed_pht[train_index] + 1;
                end else begin
                    committed_pht[train_index] <= 
                        (committed_pht[train_index] == 2'b00) ? 
                        2'b00 : committed_pht[train_index] - 1;
                end

                // On misprediction, reset speculative state
                if (train_mispredicted) begin
                    speculative_ghr <= 4'b0;
                    committed_ghr <= train_history[2:0];
                    
                    // Copy relevant committed PHT entries to speculative
                    for (integer k = 0; k < 16; k = k + 1) begin
                        speculative_pht[k] <= committed_pht[{committed_ghr, k[3:0]}];
                    end
                end
            end
            
            // Prediction updates speculative state
            if (predict_valid && (!train_valid || !train_mispredicted)) begin
                speculative_ghr <= {speculative_ghr[2:0], predict_taken};
                
                // Periodically sync speculative PHT from committed
                if (predict_pc[1:0] == 2'b00) begin
                    speculative_pht[predict_index] <= committed_pht[{committed_ghr, predict_index}];
                end
            end
        end
    end

endmodule