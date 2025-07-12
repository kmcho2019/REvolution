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

reg [1:0] ghp_table [127:0];
reg [6:0] ghp_history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Initialize tables and history
        for (int i = 0; i < 128; i++) begin
            ghp_table[i] <= 2'b0;
        end
        ghp_history <= 7'b0;
    end else begin
        if (train_valid) begin
            // Update GHP table
            if (train_taken) begin
                ghp_table[train_pc ^ train_history] <= (ghp_table[train_pc ^ train_history] == 2'b11)? 2'b11 : ghp_table[train_pc ^ train_history] + 1;
            end else begin
                ghp_table[train_pc ^ train_history] <= (ghp_table[train_pc ^ train_history] == 2'b00)? 2'b00 : ghp_table[train_pc ^ train_history] - 1;
            end

            // Recover GHP history if misprediction
            if (train_mispredicted) begin
                ghp_history <= train_history;
            end else begin
                // Update GHP history based on predicted branch direction
                if (train_taken) begin
                    ghp_history <= {ghp_history[5:0], 1'b1};
                end else begin
                    ghp_history <= {ghp_history[5:0], 1'b0};
                end
            end
        end else if (predict_valid) begin
            // Make prediction based on GHP table
            predict_taken <= (ghp_table[predict_pc ^ ghp_history] > 2'b01);
            predict_history <= ghp_history;

            // Update GHP history based on predicted branch direction
            if (predict_taken) begin
                ghp_history <= {ghp_history[5:0], 1'b1};
            end else begin
                ghp_history <= {ghp_history[5:0], 1'b0};
            end
        end
    end
end

endmodule