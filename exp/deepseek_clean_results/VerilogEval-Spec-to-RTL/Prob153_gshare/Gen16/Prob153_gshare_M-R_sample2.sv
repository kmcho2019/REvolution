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
    
    // Prediction is combinational
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = predict_valid ? pht[predict_index][1] : 1'b0;
    assign predict_history = ghr;

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;
    
    // PHT update logic using continuous assignments
    wire [1:0] next_pht_state;
    assign next_pht_state = 
        !train_valid ? pht[train_index] :
        (pht[train_index] == 2'b00) ? (train_taken ? 2'b01 : 2'b00) :
        (pht[train_index] == 2'b01) ? (train_taken ? 2'b10 : 2'b00) :
        (pht[train_index] == 2'b10) ? (train_taken ? 2'b11 : 2'b01) :
        (train_taken ? 2'b11 : 2'b10);
    
    // GHR update for training (has priority)
    wire [6:0] next_ghr_train = {train_history[5:0], train_taken};
    
    // GHR update for prediction
    wire [6:0] next_ghr_predict = {ghr[5:0], predict_taken};
    
    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // Update PHT
            if (train_valid) begin
                pht[train_index] <= next_pht_state;
            end
            
            // Update GHR - training has priority
            if (train_valid && train_mispredicted) begin
                ghr <= next_ghr_train;
            end else if (predict_valid) begin
                ghr <= next_ghr_predict;
            end
        end
    end

endmodule