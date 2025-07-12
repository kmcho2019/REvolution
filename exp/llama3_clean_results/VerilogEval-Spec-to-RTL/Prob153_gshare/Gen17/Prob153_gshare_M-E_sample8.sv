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

// Local History Predictor (LHP)
reg [1:0] lhp_table [127:0];

// Global History Predictor (GHP)
reg [1:0] ghp_table [127:0];
reg [6:0] ghp_history;

// Meta-Predictor
reg [1:0] meta_table [127:0];

// Confidence in LHP and GHP
reg [1:0] lhp_confidence [127:0];
reg [1:0] ghp_confidence [127:0];

always @(posedge clk) begin
    if (areset) begin
        // Initialize tables
        for (int i = 0; i < 128; i++) begin
            lhp_table[i] <= 2'b0;
            ghp_table[i] <= 2'b0;
            meta_table[i] <= 2'b0;
            lhp_confidence[i] <= 2'b0;
            ghp_confidence[i] <= 2'b0;
        end
        ghp_history <= 7'b0;
    end else begin
        if (train_valid) begin
            // Update LHP table
            if (train_taken) begin
                lhp_table[train_pc] <= (lhp_table[train_pc] == 2'b11)? 2'b11 : lhp_table[train_pc] + 1;
            end else begin
                lhp_table[train_pc] <= (lhp_table[train_pc] == 2'b00)? 2'b00 : lhp_table[train_pc] - 1;
            end

            // Update GHP table
            if (train_taken) begin
                ghp_table[train_pc ^ train_history] <= (ghp_table[train_pc ^ train_history] == 2'b11)? 2'b11 : ghp_table[train_pc ^ train_history] + 1;
            end else begin
                ghp_table[train_pc ^ train_history] <= (ghp_table[train_pc ^ train_history] == 2'b00)? 2'b00 : ghp_table[train_pc ^ train_history] - 1;
            end

            // Update meta-predictor confidence
            if (train_mispredicted) begin
                if (lhp_confidence[train_pc] > 2'b0) begin
                    lhp_confidence[train_pc] <= lhp_confidence[train_pc] - 1;
                end
                if (ghp_confidence[train_pc] > 2'b0) begin
                    ghp_confidence[train_pc] <= ghp_confidence[train_pc] - 1;
                end
            end else begin
                if (lhp_table[train_pc] > 2'b01) begin
                    lhp_confidence[train_pc] <= (lhp_confidence[train_pc] == 2'b11)? 2'b11 : lhp_confidence[train_pc] + 1;
                end
                if (ghp_table[train_pc ^ train_history] > 2'b01) begin
                    ghp_confidence[train_pc] <= (ghp_confidence[train_pc] == 2'b11)? 2'b11 : ghp_confidence[train_pc] + 1;
                end
            end

            // Update GHP history
            if (train_taken) begin
                ghp_history <= {ghp_history[5:0], 1'b1};
            end else begin
                ghp_history <= {ghp_history[5:0], 1'b0};
            end
        end else if (predict_valid) begin
            // Predict using meta-predictor
            if (lhp_confidence[predict_pc] > ghp_confidence[predict_pc]) begin
                predict_taken <= (lhp_table[predict_pc] > 2'b01);
            end else begin
                predict_taken <= (ghp_table[predict_pc ^ ghp_history] > 2'b01);
            end
            predict_history <= ghp_history;
        end
    end
end

endmodule