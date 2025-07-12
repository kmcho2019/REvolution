module TopModule(
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output reg predict_taken,
    output reg [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

// Gshare predictor parameters
parameter PHT_SIZE = 128;

// PHT
reg [1:0] pht [PHT_SIZE-1:0];

// Current branch history
reg [6:0] branch_history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset PHT
        for (int i = 0; i < PHT_SIZE; i++) begin
            pht[i] <= 2'b0;
        end
        // Reset branch history
        branch_history <= 7'b0;
    end else begin
        if (train_valid) begin
            // Calculate PHT index
            reg [6:0] pht_index = train_pc ^ train_history;
            // Update PHT
            if (train_taken) begin
                if (pht[pht_index] != 2'b11) pht[pht_index] <= pht[pht_index] + 1;
            end else if (pht[pht_index] != 2'b00) pht[pht_index] <= pht[pht_index] - 1;
            // Update branch history
            if (train_mispredicted) branch_history <= train_history;
        end else if (predict_valid) begin
            // Calculate PHT index
            reg [6:0] pht_index = predict_pc ^ branch_history;
            // Make prediction
            predict_taken <= (pht[pht_index] >= 2'b10) ? 1'b1 : 1'b0;
            predict_history <= branch_history;
            // Update branch history
            branch_history <= {branch_history[5:0], predict_taken};
        end
    end
end

endmodule