module TopModule(
    input               clk,
    input               areset,

    input               predict_valid,
    input     [6:0]      predict_pc,
    output              predict_taken,
    output    [6:0]      predict_history,

    input               train_valid,
    input               train_taken,
    input               train_mispredicted,
    input     [6:0]      train_history,
    input     [6:0]      train_pc
);

reg     [6:0]    history_reg;
reg     [6:0]    history_reg_next;
reg     [7:0]    pht [127:0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history_reg <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b00;
        end
    end else begin
        history_reg <= history_reg_next;
        if (train_valid) begin
            pht[{train_pc[6:1], train_history[0]}] <= train_taken ? (pht[{train_pc[6:1], train_history[0]}] + 1'b1) : (pht[{train_pc[6:1], train_history[0]}] - 1'b1);
            if (pht[{train_pc[6:1], train_history[0]}] > 2'b11) begin
                pht[{train_pc[6:1], train_history[0]}] <= 2'b11;
            end else if (pht[{train_pc[6:1], train_history[0]}] < 2'b00) begin
                pht[{train_pc[6:1], train_history[0]}] <= 2'b00;
            end
            if (train_mispredicted) begin
                history_reg <= train_history;
            end
        end
        if (predict_valid && !train_mispredicted) begin
            history_reg_next <= {history_reg[5:0], predict_taken};
        end else if (!predict_valid && train_mispredicted) begin
            history_reg_next <= train_history;
        end else begin
            history_reg_next <= history_reg;
        end
    end
end

always @(*) begin
    if (predict_valid) begin
        predict_taken = pht[{predict_pc[6:1], history_reg[0]}][1];
        predict_history = history_reg;
    end else begin
        predict_taken = 1'b0;
        predict_history = 7'b0;
    end
end

endmodule