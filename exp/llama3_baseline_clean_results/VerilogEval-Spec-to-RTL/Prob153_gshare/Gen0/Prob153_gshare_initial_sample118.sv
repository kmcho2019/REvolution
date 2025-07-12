module TopModule(
    input  clk,
    input  areset,

    input  predict_valid,
    input  [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input  train_valid,
    input  train_taken,
    input  train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);

    reg [6:0] global_history;
    reg [6:0] global_history_next;
    reg [6:0] index;
    reg [1:0] pht_value;
    reg [1:0] pht_value_next;
    reg [127:0] [1:0] pht;

    always @(*) begin
        // Hashing the PC and global history into a 7-bit index
        index = predict_pc[6:0] ^ global_history;
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'd0;
            pht <= '{default: 2'd0};
        end else begin
            if (train_valid) begin
                // Update PHT based on training
                if (train_mispredicted) begin
                    global_history <= train_history;
                end else begin
                    global_history <= global_history_next;
                end
                if (train_taken) begin
                    pht[train_pc[6:0] ^ train_history] <= (pht[train_pc[6:0] ^ train_history] == 2'd3) ? 2'd3 : pht[train_pc[6:0] ^ train_history] + 1'd1;
                end else begin
                    pht[train_pc[6:0] ^ train_history] <= (pht[train_pc[6:0] ^ train_history] == 2'd0) ? 2'd0 : pht[train_pc[6:0] ^ train_history] - 1'd1;
                end
            end else if (predict_valid) begin
                global_history <= global_history_next;
            end
        end
    end

    always @(*) begin
        // Calculate next global history for prediction
        global_history_next = global_history;
        if (predict_valid && predict_taken) begin
            global_history_next[0] = 1'b1;
        end else if (predict_valid) begin
            global_history_next[0] = 1'b0;
        end
        global_history_next[6:1] = global_history[5:0];
    end

    always @(posedge clk) begin
        // Prediction logic
        if (predict_valid) begin
            pht_value = pht[index];
            predict_taken = (pht_value >= 2'd2);
            predict_history = global_history;
        end
    end

endmodule