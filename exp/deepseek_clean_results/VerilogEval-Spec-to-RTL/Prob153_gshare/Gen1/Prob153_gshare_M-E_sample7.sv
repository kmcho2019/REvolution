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
    
    // Main and shadow Global History Registers
    reg [6:0] ghr;
    reg [6:0] shadow_ghr;
    reg shadow_valid;
    
    // PHT index calculation
    wire [6:0] current_predict_index = predict_pc ^ (shadow_valid ? shadow_ghr : ghr);
    wire [6:0] current_train_index = train_pc ^ train_history;
    
    // Prediction output (combinational)
    assign predict_taken = predict_valid ? pht[current_predict_index][1] : 1'b0;
    assign predict_history = shadow_valid ? shadow_ghr : ghr;
    
    // Next state signals
    reg [1:0] next_pht [0:127];
    reg [6:0] next_ghr;
    reg next_shadow_valid;
    reg [6:0] next_shadow_ghr;
    
    // Initialize PHT and GHR on reset
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;  // Weakly not-taken initial state
            ghr <= 7'b0;
            shadow_ghr <= 7'b0;
            shadow_valid <= 1'b0;
        end else begin
            // Update PHT
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= next_pht[i];
            
            // Update GHR state
            ghr <= next_ghr;
            shadow_ghr <= next_shadow_ghr;
            shadow_valid <= next_shadow_valid;
        end
    end

    // Combinational next state logic
    always @(*) begin
        // Default: maintain current state
        for (i = 0; i < 128; i = i + 1)
            next_pht[i] = pht[i];
        next_ghr = ghr;
        next_shadow_ghr = shadow_ghr;
        next_shadow_valid = shadow_valid;
        
        // Handle training updates (highest priority)
        if (train_valid) begin
            // Update PHT counter
            case (pht[current_train_index])
                2'b00: next_pht[current_train_index] = train_taken ? 2'b01 : 2'b00;
                2'b01: next_pht[current_train_index] = train_taken ? 2'b10 : 2'b00;
                2'b10: next_pht[current_train_index] = train_taken ? 2'b11 : 2'b01;
                2'b11: next_pht[current_train_index] = train_taken ? 2'b11 : 2'b10;
            endcase
            
            // Handle GHR updates
            if (train_mispredicted) begin
                // Misprediction recovery - override everything
                next_ghr = {train_history[5:0], train_taken};
                next_shadow_ghr = {train_history[5:0], train_taken};
                next_shadow_valid = 1'b1;
            end else begin
                // Normal training update
                next_ghr = {ghr[5:0], train_taken};
                if (shadow_valid) begin
                    next_shadow_ghr = {shadow_ghr[5:0], train_taken};
                end
            end
        end
        // Handle prediction updates (lower priority)
        else if (predict_valid) begin
            next_ghr = {ghr[5:0], predict_taken};
            if (shadow_valid) begin
                next_shadow_ghr = {shadow_ghr[5:0], predict_taken};
            end
        end
        
        // Clear shadow after one cycle
        if (shadow_valid && !train_mispredicted) begin
            next_shadow_valid = 1'b0;
        end
    end

endmodule