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

reg [6:0] branch_history;
reg [6:0] pht_index;
reg [1:0] pht_entry;
reg [1:0] pht [127:0]; // 128-entry table of two-bit saturating counters

always @(posedge clk or posedge areset) begin
    if (areset) begin
        branch_history <= 7'b0;
        pht_index <= 7'b0;
        pht_entry <= 2'b0;
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else begin
        if (train_valid) begin
            // Update PHT
            pht_index <= (train_pc ^ train_history);
            if (train_taken) begin
                if (pht[pht_index] != 2'b11) begin
                    pht[pht_index] <= pht[pht_index] + 1;
                end
            end else begin
                if (pht[pht_index] != 2'b00) begin
                    pht[pht_index] <= pht[pht_index] - 1;
                end
            end

            // Recover branch history if misprediction
            if (train_mispredicted) begin
                branch_history <= train_history;
            end else if (!predict_valid) begin
                // Update branch history
                if (train_taken) begin
                    branch_history <= {train_history[5:0], 1'b1};
                end else begin
                    branch_history <= {train_history[5:0], 1'b0};
                end
            end
        end else if (predict_valid) begin
            // Make prediction
            pht_index <= (predict_pc ^ branch_history);
            if (pht[pht_index] >= 2'b10) begin
                predict_taken <= 1'b1;
            end else begin
                predict_taken <= 1'b0;
            end
            predict_history <= branch_history;

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