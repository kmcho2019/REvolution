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
    reg [127:0] [1:0] pht;

    // Initialize global history and PHT on reset
    always @(posedge areset or negedge clk) begin
        if (areset) begin
            global_history <= 7'd0;
            for (int i = 0; i < 128; i++) begin
                pht[i] <= 2'd0;
            end
        end else if (!areset && clk) begin
            // Update global history on prediction
            if (predict_valid) begin
                global_history <= {global_history[5:0], predict_taken};
            end

            // Update global history on misprediction
            if (train_valid && train_mispredicted) begin
                global_history <= train_history;
            end
        end
    end

    // Prediction logic
    wire [6:0] predict_index;
    assign predict_index = predict_pc ^ global_history;
    wire [1:0] predict_pht_value;
    assign predict_pht_value = pht[predict_index];

    always @(posedge clk) begin
        if (predict_valid) begin
            if (predict_pht_value == 2'd0 || predict_pht_value == 2'd1) begin
                predict_taken <= 1'b0;
            end else begin
                predict_taken <= 1'b1;
            end
            predict_history <= global_history;
        end
    end

    // Training logic
    wire [6:0] train_index;
    assign train_index = train_pc ^ train_history;
    reg [1:0] train_pht_value;

    always @(posedge clk) begin
        if (train_valid) begin
            train_pht_value <= pht[train_index];
            if (train_mispredicted) begin
                if (train_taken) begin
                    pht[train_index] <= (train_pht_value == 2'd3) ? 2'd3 : train_pht_value + 1'b1;
                end else begin
                    pht[train_index] <= (train_pht_value == 2'd0) ? 2'd0 : train_pht_value - 1'b1;
                end
            end else begin
                if (train_taken) begin
                    pht[train_index] <= (train_pht_value == 2'd3) ? 2'd3 : train_pht_value + 1'b1;
                end else begin
                    pht[train_index] <= (train_pht_value == 2'd0) ? 2'd0 : train_pht_value - 1'b1;
                end
            end
        end
    end

endmodule