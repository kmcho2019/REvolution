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

    // Dual GHR implementation
    reg [6:0] committed_ghr;  // Committed state for training
    reg [6:0] speculative_ghr; // Speculative state for prediction

    // Dual PHT implementation
    reg [1:0] main_pht [0:127];   // Committed PHT
    reg [1:0] shadow_pht [0:127]; // Speculative PHT

    // Prediction logic uses speculative state
    wire [6:0] predict_index = predict_pc ^ speculative_ghr;
    assign predict_taken = shadow_pht[predict_index][1];
    assign predict_history = speculative_ghr;

    // Training index uses committed history
    wire [6:0] train_index = train_pc ^ train_history;

    // Speculative update during prediction
    wire [6:0] next_speculative_ghr = {speculative_ghr[5:0], predict_taken};
    wire [6:0] next_speculative_index = predict_pc ^ next_speculative_ghr;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            committed_ghr <= 7'b0;
            speculative_ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                main_pht[i] <= 2'b01;
                shadow_pht[i] <= 2'b01;
            end
        end else begin
            // Handle training (highest priority)
            if (train_valid) begin
                // Update main PHT based on actual outcome
                if (train_taken) begin
                    main_pht[train_index] <= (main_pht[train_index] == 2'b11) ? 
                        2'b11 : main_pht[train_index] + 1;
                end else begin
                    main_pht[train_index] <= (main_pht[train_index] == 2'b00) ? 
                        2'b00 : main_pht[train_index] - 1;
                end

                // On misprediction, rollback speculative state
                if (train_mispredicted) begin
                    speculative_ghr <= {train_history[5:0], train_taken};
                    // Copy main PHT to shadow PHT
                    for (integer i = 0; i < 128; i = i + 1) begin
                        shadow_pht[i] <= main_pht[i];
                    end
                end else begin
                    // Commit speculative updates to main PHT
                    if (predict_valid) begin
                        shadow_pht[next_speculative_index] <= main_pht[next_speculative_index];
                    end
                end
                
                // Update committed GHR
                committed_ghr <= {train_history[5:0], train_taken};
            end 
            // Handle prediction when no training
            else if (predict_valid) begin
                // Speculatively update GHR and PHT
                speculative_ghr <= next_speculative_ghr;
                shadow_pht[next_speculative_index] <= shadow_pht[predict_index];
            end
        end
    end

    // Continuous copy from main to shadow PHT when no prediction is happening
    always @(*) begin
        if (!predict_valid) begin
            for (integer i = 0; i < 128; i = i + 1) begin
                shadow_pht[i] = main_pht[i];
            end
        end
    end

endmodule