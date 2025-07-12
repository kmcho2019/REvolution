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
    reg [127:0] [1:0] pht;
    reg [127:0] [1:0] pht_next;

    // Hash function to calculate index
    wire [6:0] index;
    assign index = predict_pc ^ global_history;

    // Prediction interface
    assign predict_taken = (pht[index] >= 2'b02);
    assign predict_history = global_history;

    // Training interface
    always @(*) begin
        global_history_next = global_history;
        pht_next = pht;

        if (train_valid) begin
            // Update PHT
            if (train_taken && train_mispredicted) begin
                // Strongly taken
                pht_next[{train_pc, train_history}[6:0]] = (pht[{train_pc, train_history}[6:0]] == 2'b11) ? 2'b11 : (pht[{train_pc, train_history}[6:0]] + 2'b01);
            end else if (train_taken && !train_mispredicted) begin
                // Weakly taken
                pht_next[{train_pc, train_history}[6:0]] = (pht[{train_pc, train_history}[6:0]] == 2'b11) ? 2'b11 : (pht[{train_pc, train_history}[6:0]] + 2'b01);
            end else if (!train_taken && train_mispredicted) begin
                // Strongly not taken
                pht_next[{train_pc, train_history}[6:0]] = (pht[{train_pc, train_history}[6:0]] == 2'b00) ? 2'b00 : (pht[{train_pc, train_history}[6:0]] - 2'b01);
            end else begin
                // Weakly not taken
                pht_next[{train_pc, train_history}[6:0]] = (pht[{train_pc, train_history}[6:0]] == 2'b00) ? 2'b00 : (pht[{train_pc, train_history}[6:0]] - 2'b01);
            end

            // Update GBHR if mispredicted
            if (train_mispredicted) begin
                global_history_next = train_history;
            end
        end

        // Update GBHR for prediction
        if (predict_valid) begin
            global_history_next = {global_history[5:0], predict_taken};
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            pht <= {128{2'b01}};
        end else begin
            global_history <= global_history_next;
            pht <= pht_next;
        end
    end

endmodule