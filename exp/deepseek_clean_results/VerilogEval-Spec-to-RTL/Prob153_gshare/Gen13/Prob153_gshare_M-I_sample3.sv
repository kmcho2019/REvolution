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

    // 7-bit global history register
    reg [6:0] ghr;
    // 128-entry pattern history table (2-bit saturating counters)
    reg [1:0] pht [0:127];
    
    // Registered training pipeline
    reg train_valid_reg;
    reg [6:0] train_index_reg;
    reg train_taken_reg;
    wire pht_write_en = train_valid_reg;

    // Shared XOR logic
    wire [6:0] shared_xor_in = train_valid ? train_pc : predict_pc;
    wire [6:0] shared_xor_out = shared_xor_in ^ (train_valid ? train_history : ghr);
    
    // Prediction logic
    wire [6:0] predict_index = shared_xor_out;
    wire [1:0] predict_pht_value = pht[predict_index];
    assign predict_taken = predict_pht_value[1];  // MSB determines prediction
    assign predict_history = ghr;

    // Training index (from shared XOR)
    wire [6:0] train_index = shared_xor_out;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and initialize PHT with reduced operations
            ghr <= 7'b0;
            train_valid_reg <= 1'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // Register training signals
            train_valid_reg <= train_valid;
            train_index_reg <= train_index;
            train_taken_reg <= train_taken;
            
            // Clock-gated PHT update
            if (pht_write_en) begin
                if (train_taken_reg) begin
                    pht[train_index_reg] <= (pht[train_index_reg] == 2'b11) ? 2'b11 : pht[train_index_reg] + 1;
                end else begin
                    pht[train_index_reg] <= (pht[train_index_reg] == 2'b00) ? 2'b00 : pht[train_index_reg] - 1;
                end
            end
            
            // Valid-gated GHR updates
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid && (!train_valid || !train_mispredicted)) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule