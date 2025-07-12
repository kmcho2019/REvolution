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

    // Dual-ported PHT implementation
    reg [1:0] pht [0:127];
    reg [1:0] pht_read_data;
    
    // Main and shadow GHR registers
    reg [6:0] ghr;
    reg [6:0] shadow_ghr;
    
    // Pipelined index registers
    reg [6:0] predict_index_reg;
    reg [6:0] train_index_reg;
    
    // Calculate indices
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ (train_mispredicted ? train_history : ghr);
    
    // Prediction output
    assign predict_taken = predict_valid ? pht_read_data[1] : 1'b0;
    assign predict_history = ghr;
    
    // PHT update logic
    always @(*) begin
        case (pht[train_index_reg])
            2'b00: pht[train_index_reg] = train_taken ? 2'b01 : 2'b00;
            2'b01: pht[train_index_reg] = train_taken ? 2'b10 : 2'b00;
            2'b10: pht[train_index_reg] = train_taken ? 2'b11 : 2'b01;
            2'b11: pht[train_index_reg] = train_taken ? 2'b11 : 2'b10;
        endcase
    end
    
    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize GHR and PHT
            ghr <= 7'b0;
            shadow_ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // Pipeline stage 1: Register indices
            predict_index_reg <= predict_index;
            train_index_reg <= train_index;
            
            // Pipeline stage 2: PHT read
            pht_read_data <= pht[predict_index_reg];
            
            // Handle training updates
            if (train_valid) begin
                // PHT update happens through continuous assignment
                
                // Update shadow GHR for misprediction recovery
                shadow_ghr <= {train_history[5:0], train_taken};
            end
            
            // GHR update with priority to training
            if (train_valid && train_mispredicted) begin
                ghr <= shadow_ghr;
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], pht_read_data[1]};
            end
        end
    end

endmodule