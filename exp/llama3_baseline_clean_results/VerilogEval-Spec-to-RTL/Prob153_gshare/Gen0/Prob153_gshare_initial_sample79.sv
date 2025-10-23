module TopModule(
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

reg [6:0] global_history;
reg [6:0] global_history_next;
reg [7:0] pht_index;
reg [1:0] pht_entry;
reg [1:0] pht_entry_next;

reg [127:0] pht [1:0]; // 128 entries of 2-bit saturating counters

always @(*) begin
    // Calculate the index for the PHT
    pht_index = {predict_pc[6:0]} ^ global_history;
    
    // Predict the branch direction
    if (pht[pht_index[6:0]][1:0] >= 2) begin
        predict_taken = 1;
    end else begin
        predict_taken = 0;
    end
    
    predict_history = global_history;
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else begin
        if (train_valid && train_mispredicted) begin
            global_history <= train_history;
        end else if (predict_valid) begin
            global_history <= {global_history[5:0], predict_taken};
        end
        
        if (train_valid) begin
            pht_index = {train_pc[6:0]} ^ train_history;
            if (train_taken) begin
                if (pht[pht_index[6:0]][1:0] < 2'b11) begin
                    pht[pht_index[6:0]] <= pht[pht_index[6:0]] + 1;
                end
            end else begin
                if (pht[pht_index[6:0]][1:0] > 2'b00) begin
                    pht[pht_index[6:0]] <= pht[pht_index[6:0]] - 1;
                end
            end
        end
    end
end

endmodule