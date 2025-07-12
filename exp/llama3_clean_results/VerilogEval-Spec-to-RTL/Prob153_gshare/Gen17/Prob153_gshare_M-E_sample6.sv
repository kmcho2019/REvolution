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

reg [6:0] global_history;
reg [1:0] pht [127:0];

wire [6:0] predict_index;
wire [6:0] train_index;

assign predict_index = predict_pc ^ global_history;
assign train_index = train_pc ^ train_history;

reg [6:0] temp_global_history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b00;
        end
    end else begin
        if (train_valid) begin
            if (train_mispredicted) begin
                global_history <= train_history;
            end else begin
                global_history <= {global_history[5:0], train_taken};
            end

            if (train_taken) begin
                if (pht[train_index] == 2'b11) begin
                    pht[train_index] <= 2'b11;
                end else begin
                    pht[train_index] <= pht[train_index] + 1'b1;
                end
            end else begin
                if (pht[train_index] == 2'b00) begin
                    pht[train_index] <= 2'b00;
                end else begin
                    pht[train_index] <= pht[train_index] - 1'b1;
                end
            end
        end

        if (predict_valid) begin
            predict_history <= global_history;
            if (pht[predict_index] >= 2'b10) begin
                predict_taken <= 1'b1;
            end else begin
                predict_taken <= 1'b0;
            end

            // Update global_history at the next positive clock edge
            if (!train_valid || train_index != predict_index) begin
                temp_global_history <= {global_history[5:0], (pht[predict_index] >= 2'b10) ? 1'b1 : 1'b0};
            end else begin
                temp_global_history <= global_history;
            end
        end

        // Update global_history from temp_global_history
        if (!train_valid) begin
            global_history <= temp_global_history;
        end
    end
end

// Hierarchical structure
reg [1:0] pht_level1 [7:0];
reg [1:0] pht_level2 [7:0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        for (int i = 0; i < 8; i++) begin
            pht_level1[i] <= 2'b00;
            pht_level2[i] <= 2'b00;
        end
    end else begin
        if (train_valid) begin
            // Update pht_level1
            if (train_taken) begin
                if (pht_level1[train_index[2:0]] == 2'b11) begin
                    pht_level1[train_index[2:0]] <= 2'b11;
                end else begin
                    pht_level1[train_index[2:0]] <= pht_level1[train_index[2:0]] + 1'b1;
                end
            end else begin
                if (pht_level1[train_index[2:0]] == 2'b00) begin
                    pht_level1[train_index[2:0]] <= 2'b00;
                end else begin
                    pht_level1[train_index[2:0]] <= pht_level1[train_index[2:0]] - 1'b1;
                end
            end

            // Update pht_level2
            if (train_taken) begin
                if (pht_level2[train_index[5:3]] == 2'b11) begin
                    pht_level2[train_index[5:3]] <= 2'b11;
                end else begin
                    pht_level2[train_index[5:3]] <= pht_level2[train_index[5:3]] + 1'b1;
                end
            end else begin
                if (pht_level2[train_index[5:3]] == 2'b00) begin
                    pht_level2[train_index[5:3]] <= 2'b00;
                end else begin
                    pht_level2[train_index[5:3]] <= pht_level2[train_index[5:3]] - 1'b1;
                end
            end
        end

        if (predict_valid) begin
            // Make prediction using pht_level1 and pht_level2
            if (pht_level1[predict_index[2:0]] >= 2'b10 && pht_level2[predict_index[5:3]] >= 2'b10) begin
                predict_taken <= 1'b1;
            end else begin
                predict_taken <= 1'b0;
            end
        end
    end
end

endmodule