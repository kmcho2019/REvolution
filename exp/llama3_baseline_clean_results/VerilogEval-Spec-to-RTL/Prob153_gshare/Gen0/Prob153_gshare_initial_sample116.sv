module TopModule(
    input               clk,
    input               areset,

    input               predict_valid,
    input      [6:0]    predict_pc,
    output reg           predict_taken,
    output reg  [6:0]   predict_history,

    input               train_valid,
    input               train_taken,
    input               train_mispredicted,
    input      [6:0]    train_history,
    input      [6:0]    train_pc
);

reg     [6:0]   global_history;
reg     [6:0]   global_history_next;
reg     [1:0]   pht [127:0];
reg     [6:0]   pht_index;

always @(*) begin
    pht_index = {predict_pc[6:1]} ^ global_history;
    if (pht[pht_index] == 2'b11) begin
        predict_taken = 1'b1;
    end else if (pht[pht_index] == 2'b00) begin
        predict_taken = 1'b0;
    end else begin
        predict_taken = pht[pht_index][1];
    end
    predict_history = global_history;
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else begin
        if (train_valid) begin
            if (train_taken) begin
                if (pht[{train_pc[6:1]} ^ train_history] < 2'b11) begin
                    pht[{train_pc[6:1]} ^ train_history] <= pht[{train_pc[6:1]} ^ train_history] + 1'b1;
                end
            end else begin
                if (pht[{train_pc[6:1]} ^ train_history] > 2'b00) begin
                    pht[{train_pc[6:1]} ^ train_history] <= pht[{train_pc[6:1]} ^ train_history] - 1'b1;
                end
            end
            if (train_mispredicted) begin
                global_history <= train_history;
            end else if (predict_valid) begin
                global_history <= {global_history[5:0], predict_taken};
            end else begin
                global_history <= global_history;
            end
        end else if (predict_valid) begin
            global_history <= {global_history[5:0], predict_taken};
        end else begin
            global_history <= global_history;
        end
    end
end

endmodule