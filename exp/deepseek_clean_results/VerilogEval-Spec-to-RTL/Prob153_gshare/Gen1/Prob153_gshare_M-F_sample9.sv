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

    // Pattern History Table (128 entries of 2-bit counters)
    reg [1:0] pht [0:127];
    
    // Global History Register
    reg [6:0] ghr;
    
    // Current prediction index and PHT read
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [1:0] current_pht = pht[predict_index];
    assign predict_taken = current_pht[1];  // MSB determines prediction
    assign predict_history = ghr;
    
    // Training index calculation
    wire [6:0] train_index = train_pc ^ train_history;
    
    // Next state signals
    reg [6:0] next_ghr;
    reg ghr_update;
    reg [1:0] next_pht [0:127];
    reg pht_update;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset all PHT entries to weakly not taken (01)
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            ghr <= 7'b0;
        end else begin
            // Update PHT if training occurred
            if (pht_update) begin
                pht[train_index] <= next_pht[train_index];
            end
            
            // Update GHR if needed
            if (ghr_update) begin
                ghr <= next_ghr;
            end
        end
    end
    
    // Combinational logic for next state
    always @(*) begin
        // Default assignments
        ghr_update = 1'b0;
        next_ghr = ghr;
        pht_update = 1'b0;
        
        // Initialize next_pht to current values
        for (integer i = 0; i < 128; i = i + 1) begin
            next_pht[i] = pht[i];
        end

        // Training has absolute priority
        if (train_valid) begin
            // Update PHT
            case (pht[train_index])
                2'b00: next_pht[train_index] = train_taken ? 2'b01 : 2'b00;
                2'b01: next_pht[train_index] = train_taken ? 2'b10 : 2'b00;
                2'b10: next_pht[train_index] = train_taken ? 2'b11 : 2'b01;
                2'b11: next_pht[train_index] = train_taken ? 2'b11 : 2'b10;
            endcase
            pht_update = 1'b1;
            
            // Update GHR
            if (train_mispredicted) begin
                // On misprediction, restore GHR to train_history shifted by actual outcome
                next_ghr = {train_history[5:0], train_taken};
            end else begin
                // Normal training update
                next_ghr = {train_history[5:0], train_taken};
            end
            ghr_update = 1'b1;
        end else if (predict_valid) begin
            // Only update GHR for prediction if no training occurred
            next_ghr = {ghr[5:0], predict_taken};
            ghr_update = 1'b1;
        end
    end

endmodule