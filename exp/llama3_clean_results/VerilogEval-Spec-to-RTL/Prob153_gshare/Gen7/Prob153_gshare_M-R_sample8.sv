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

// Prediction logic
assign predict_taken = (pht[predict_pc ^ branch_history] >= 2'b10)? 1'b1 : 1'b0;
assign predict_history = branch_history;

// Training logic
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
            // Update PHT
            if (train_taken) begin
                if (pht[train_pc ^ train_history]!= 2'b11) begin
                    pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] + 1;
                end
            end else begin
                if (pht[train_pc ^ train_history]!= 2'b00) begin
                    pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] - 1;
                end
            end

            // Recover branch history if misprediction
            if (train_mispredicted) begin
                branch_history <= train_history;
            end else if (predict_valid) begin
                // Update branch history
                if (predict_taken) begin
                    branch_history <= {branch_history[5:0], 1'b1};
                end else begin
                    branch_history <= {branch_history[5:0], 1'b0};
                end
            end
        end else if (predict_valid) begin
            // Update branch history
            if (predict_taken) begin
                branch_history <= {branch_history[5:0], 1'b1};
            end else begin
                branch_history <= {branch_history[5:0], 1'b0};
            end
        end
    end
end

endmodule