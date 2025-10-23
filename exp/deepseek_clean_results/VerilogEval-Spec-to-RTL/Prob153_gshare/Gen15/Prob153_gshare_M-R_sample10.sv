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

    // Prediction index calculation
    wire [6:0] predict_index = predict_pc ^ ghr;
    
    // Continuous assignments for prediction outputs
    assign predict_taken = pht[predict_index][1];
    assign predict_history = ghr;

    // Training index calculation
    wire [6:0] train_index = train_pc ^ train_history;
    
    // Next state of PHT entry being trained
    wire [1:0] next_pht_state;
    assign next_pht_state = train_taken ? 
                           (pht[train_index] == 2'b11 ? 2'b11 : pht[train_index] + 1) :
                           (pht[train_index] == 2'b00 ? 2'b00 : pht[train_index] - 1);

    // PHT update logic (training)
    always @(posedge clk) begin
        if (train_valid) begin
            pht[train_index] <= next_pht_state;
        end
    end

    // PHT and GHR reset logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
        end
    end

    // GHR update logic
    always @(posedge clk) begin
        if (!areset) begin
            // Training has priority
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end
            // Prediction update when no training misprediction
            else if (predict_valid && (!train_valid || !train_mispredicted)) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule