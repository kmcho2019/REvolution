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

    // 7-bit global branch history register
    reg [6:0] history_reg;
    reg [6:0] history_reg_next;

    // 128-entry table of two-bit saturating counters
    reg [1:0] pht [127:0];
    reg [1:0] pht_next [127:0];

    // Hash function
    wire [6:0] index;
    assign index = predict_pc ^ history_reg;

    // Make predictions
    wire predict_taken_comb;
    assign predict_taken_comb = (pht[index] >= 2'b10);

    // Update prediction history table
    always @(*) begin
        history_reg_next = history_reg;
        for (int i = 0; i < 128; i++) begin
            pht_next[i] = pht[i];
        end

        if (train_valid) begin
            if (train_taken) begin
                if (pht[train_pc ^ train_history] != 2'b11) begin
                    pht_next[train_pc ^ train_history] = pht[train_pc ^ train_history] + 1'b1;
                end
            end else begin
                if (pht[train_pc ^ train_history] != 2'b00) begin
                    pht_next[train_pc ^ train_history] = pht[train_pc ^ train_history] - 1'b1;
                end
            end

            if (train_mispredicted) begin
                history_reg_next = train_history;
            end
        end

        if (predict_valid && !train_mispredicted) begin
            if (predict_taken_comb) begin
                history_reg_next = {history_reg[5:0], 1'b1};
            end else begin
                history_reg_next = {history_reg[5:0], 1'b0};
            end
        end
    end

    // Update registers
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 7'b0;
            for (int i = 0; i < 128; i++) begin
                pht[i] <= 2'b01;
            end
        end else begin
            history_reg <= history_reg_next;
            for (int i = 0; i < 128; i++) begin
                pht[i] <= pht_next[i];
            end
        end
    end

    // Output assignments
    assign predict_taken = predict_taken_comb;
    assign predict_history = history_reg;

endmodule