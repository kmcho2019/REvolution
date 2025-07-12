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

    // Dual GHR system
    reg [6:0] predict_ghr;  // Used for predictions
    reg [6:0] train_ghr;    // Used for training
    
    // PHT memory
    reg [1:0] pht [0:127];
    
    // Training buffer (registered for delayed PHT update)
    reg train_valid_delayed;
    reg [6:0] train_index_delayed;
    reg [1:0] updated_counter;
    
    // Prediction index calculation
    wire [6:0] predict_index = predict_pc ^ predict_ghr;
    
    // Output assignments
    assign predict_taken = predict_valid ? pht[predict_index][1] : 1'b0;
    assign predict_history = predict_ghr;
    
    // Training index calculation (uses train_ghr or train_history)
    wire [6:0] train_index = train_pc ^ (train_mispredicted ? train_history : train_ghr);
    
    // Saturing counter update logic
    always @(*) begin
        if (train_valid) begin
            updated_counter = pht[train_index];
            if (train_taken) begin
                updated_counter = (updated_counter == 2'b11) ? 2'b11 : updated_counter + 1;
            end else begin
                updated_counter = (updated_counter == 2'b00) ? 2'b00 : updated_counter - 1;
            end
        end
    end
    
    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize both GHRs
            predict_ghr <= 7'b0;
            train_ghr <= 7'b0;
            
            // Initialize PHT to weakly taken
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b10;
            end
            
            // Clear delayed training signals
            train_valid_delayed <= 1'b0;
        end else begin
            // Buffer training request for delayed PHT update
            train_valid_delayed <= train_valid;
            train_index_delayed <= train_index;
            
            // Apply delayed PHT update
            if (train_valid_delayed) begin
                pht[train_index_delayed] <= updated_counter;
            end
            
            // Update training GHR (highest priority)
            if (train_valid && train_mispredicted) begin
                train_ghr <= {train_history[5:0], train_taken};
            end else if (train_valid) begin
                train_ghr <= {train_ghr[5:0], train_taken};
            end
            
            // Update prediction GHR (follows one cycle behind)
            predict_ghr <= train_ghr;
            
            // Handle prediction updates when no training occurs
            if (!train_valid && predict_valid) begin
                predict_ghr <= {predict_ghr[5:0], predict_taken};
            end
        end
    end

endmodule