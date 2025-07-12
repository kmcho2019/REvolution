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

    // Main GHR and shadow GHR for recovery
    reg [6:0] ghr;
    reg [6:0] shadow_ghr;
    
    // Dual-port PHT (128 entries x 2 bits)
    reg [1:0] pht [0:127];
    
    // Prediction path (combinational)
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = predict_valid ? pht[predict_index][1] : 1'b0;
    assign predict_history = ghr;
    
    // Training path
    wire [6:0] train_index = train_pc ^ train_history;
    reg [1:0] next_pht_state;
    
    // Speculative GHR update
    wire [6:0] next_ghr = {ghr[5:0], predict_taken};
    
    // PHT update logic
    always @(*) begin
        if (train_valid) begin
            case (pht[train_index])
                2'b00: next_pht_state = train_taken ? 2'b01 : 2'b00;
                2'b01: next_pht_state = train_taken ? 2'b10 : 2'b00;
                2'b10: next_pht_state = train_taken ? 2'b11 : 2'b01;
                2'b11: next_pht_state = train_taken ? 2'b11 : 2'b10;
                default: next_pht_state = pht[train_index];
            endcase
        end else begin
            next_pht_state = pht[train_index];
        end
    end
    
    // Sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            shadow_ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // Update PHT if training
            if (train_valid) begin
                pht[train_index] <= next_pht_state;
            end
            
            // Update GHR - training has priority
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
                shadow_ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= next_ghr;
                shadow_ghr <= next_ghr;  // Keep shadow in sync
            end
            
            // On misprediction without training (shouldn't happen per spec)
            if (train_mispredicted && !train_valid) begin
                ghr <= shadow_ghr;
            end
        end
    end

endmodule