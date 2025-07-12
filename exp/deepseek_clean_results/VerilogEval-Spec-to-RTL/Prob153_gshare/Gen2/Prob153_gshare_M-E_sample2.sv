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
    reg [6:0] ghr_pred;  // For predictions
    reg [6:0] ghr_train; // For training
    
    // 128-entry PHT with 2-bit saturating counters
    reg [1:0] pht [0:127];
    
    // Prediction path
    wire [6:0] pred_index = predict_pc ^ ghr_pred;
    assign predict_taken = pht[pred_index][1];
    assign predict_history = ghr_pred;
    
    // Training path
    wire [6:0] train_index = train_pc ^ ghr_train;
    wire [1:0] current_counter = pht[train_index];
    
    // Next counter value calculation
    wire [1:0] next_counter;
    assign next_counter = train_taken ?
                         (current_counter == 2'b11 ? 2'b11 : current_counter + 1) :
                         (current_counter == 2'b00 ? 2'b00 : current_counter - 1);
    
    // GHR update logic
    reg [6:0] next_ghr_pred, next_ghr_train;
    always @(*) begin
        // Default hold values
        next_ghr_pred = ghr_pred;
        next_ghr_train = ghr_train;
        
        // Misprediction recovery (highest priority)
        if (train_valid && train_mispredicted) begin
            next_ghr_pred = {train_history[5:0], train_taken};
            next_ghr_train = {train_history[5:0], train_taken};
        end
        else begin
            // Normal training update
            if (train_valid) begin
                next_ghr_train = {ghr_train[5:0], train_taken};
            end
            
            // Prediction update (lower priority than training)
            if (predict_valid && !(train_valid && train_mispredicted)) begin
                next_ghr_pred = {ghr_pred[5:0], predict_taken};
            end
        end
    end
    
    // Sequential logic
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr_pred <= 7'b0;
            ghr_train <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken initial state
            end
        end else begin
            // Update PHT for training
            if (train_valid) begin
                pht[train_index] <= next_counter;
            end
            
            // Update GHR registers
            ghr_pred <= next_ghr_pred;
            ghr_train <= next_ghr_train;
        end
    end

endmodule