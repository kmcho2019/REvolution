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

    // Dual PHT structure (main and shadow)
    reg [1:0] pht_main [0:127];
    reg [1:0] pht_shadow [0:127];
    reg [6:0] shadow_index;
    reg shadow_valid;
    
    // Dual GHR registers
    reg [6:0] ghr_committed;  // Committed history
    reg [6:0] ghr_speculative; // Speculative history
    
    // Prediction index
    wire [6:0] predict_index = predict_pc ^ ghr_speculative;
    
    // Training index
    wire [6:0] train_index = train_pc ^ train_history;
    
    // PHT read mux (gives priority to shadow entry if active)
    wire [1:0] pht_read = (shadow_valid && (predict_index == shadow_index)) ? 
                         pht_shadow[predict_index] : pht_main[predict_index];
    
    assign predict_taken = pht_read[1];
    assign predict_history = ghr_speculative;
    
    // Initialize PHTs
    integer i;
    initial begin
        for (i = 0; i < 128; i = i + 1) begin
            pht_main[i] = 2'b01;
            pht_shadow[i] = 2'b01;
        end
        shadow_valid = 0;
    end
    
    // Training update logic
    wire [1:0] updated_counter;
    always @(*) begin
        case (pht_main[train_index])
            2'b00: updated_counter = train_taken ? 2'b01 : 2'b00;
            2'b01: updated_counter = train_taken ? 2'b10 : 2'b00;
            2'b10: updated_counter = train_taken ? 2'b11 : 2'b01;
            2'b11: updated_counter = train_taken ? 2'b11 : 2'b10;
        endcase
    end
    
    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr_committed <= 7'b0;
            ghr_speculative <= 7'b0;
            shadow_valid <= 0;
            for (i = 0; i < 128; i = i + 1) begin
                pht_main[i] <= 2'b01;
                pht_shadow[i] <= 2'b01;
            end
        end else begin
            // Phase 1: Handle training (highest priority)
            if (train_valid) begin
                // Stage training update in shadow PHT
                pht_shadow[train_index] <= updated_counter;
                shadow_index <= train_index;
                shadow_valid <= 1;
                
                // Handle misprediction recovery
                if (train_mispredicted) begin
                    ghr_committed <= {train_history[5:0], train_taken};
                    ghr_speculative <= {train_history[5:0], train_taken};
                end
            end else begin
                shadow_valid <= 0;
            end
            
            // Phase 2: Handle predictions (medium priority)
            if (predict_valid && !(train_valid && train_mispredicted)) begin
                ghr_speculative <= {ghr_speculative[5:0], predict_taken};
            end
            
            // Phase 3: Commit speculative state (lowest priority)
            if (!train_valid) begin
                ghr_committed <= ghr_speculative;
            end
            
            // Phase 4: Write back shadow PHT updates
            if (shadow_valid) begin
                pht_main[shadow_index] <= pht_shadow[shadow_index];
                shadow_valid <= 0;
            end
        end
    end
endmodule