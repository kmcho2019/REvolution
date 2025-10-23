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

    // Current state registers
    reg [6:0] ghr;
    reg [1:0] pht [0:127];
    
    // Next state registers
    reg [6:0] next_ghr;
    reg [1:0] next_pht [0:127];
    reg pht_update_needed;

    // Prediction logic
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];
    assign predict_history = ghr;

    // Training logic
    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] current_counter = pht[train_index];
    wire [1:0] updated_counter = train_taken ? 
                               (current_counter == 2'b11 ? 2'b11 : current_counter + 1) :
                               (current_counter == 2'b00 ? 2'b00 : current_counter - 1);

    always @(*) begin
        // Default next state is current state
        next_ghr = ghr;
        pht_update_needed = 0;
        
        // Training has priority over prediction
        if (train_valid) begin
            // Schedule PHT update for next cycle
            next_pht[train_index] = updated_counter;
            pht_update_needed = 1;
            
            // Update GHR immediately if mispredicted
            if (train_mispredicted)
                next_ghr = {train_history[5:0], train_taken};
        end 
        // Only update GHR for prediction if no training occurred
        else if (predict_valid) begin
            next_ghr = {ghr[5:0], predict_taken};
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
        end else begin
            // Update GHR
            ghr <= next_ghr;
            
            // Update PHT if training occurred
            if (pht_update_needed)
                pht[train_index] <= next_pht[train_index];
        end
    end

endmodule