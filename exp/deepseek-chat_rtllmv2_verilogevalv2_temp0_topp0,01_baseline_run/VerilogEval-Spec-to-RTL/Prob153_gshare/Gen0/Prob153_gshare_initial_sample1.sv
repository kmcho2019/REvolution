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
    
    // Prediction logic
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];  // MSB determines prediction
    assign predict_history = ghr;
    
    // Training logic
    wire [6:0] train_index = train_pc ^ train_history;
    reg [1:0] train_pht_update;
    
    // Update PHT on training
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken initial state
            end
        end else begin
            // Training has priority over prediction
            if (train_valid) begin
                // Update PHT
                if (train_taken) begin
                    // Increment counter (saturating at 3)
                    pht[train_index] <= (pht[train_index] == 2'b11) ? 2'b11 : pht[train_index] + 1;
                end else begin
                    // Decrement counter (saturating at 0)
                    pht[train_index] <= (pht[train_index] == 2'b00) ? 2'b00 : pht[train_index] - 1;
                end
                
                // Update GHR if mispredicted (recover) or normal training
                if (train_mispredicted) begin
                    ghr <= {train_history[5:0], train_taken};
                end else begin
                    ghr <= {ghr[5:0], train_taken};
                end
            end else if (predict_valid) begin
                // Only update GHR with prediction if not training
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule