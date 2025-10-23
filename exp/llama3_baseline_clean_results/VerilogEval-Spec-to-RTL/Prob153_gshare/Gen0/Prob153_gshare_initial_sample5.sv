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
    reg [1:0] pht [127:0];

    assign predict_taken = (pht[{predict_pc[6:1], predict_history[0]}] > 1) ? 1'b1 : 1'b0;
    assign predict_history = global_history;

    always @(*) begin
        global_history_next = global_history;
        if (predict_valid) begin
            global_history_next = {global_history[5:0], predict_taken};
        end
        if (train_valid && train_mispredicted) begin
            global_history_next = train_history;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            for (int i = 0; i < 128; i++) begin
                pht[i] <= 2'b0;
            end
        end else begin
            global_history <= global_history_next;
            if (train_valid) begin
                if (train_taken) begin
                    if (pht[{train_pc[6:1], train_history[0]}] != 2'b11) begin
                        pht[{train_pc[6:1], train_history[0]}] <= pht[{train_pc[6:1], train_history[0]}] + 1;
                    end
                end else begin
                    if (pht[{train_pc[6:1], train_history[0]}] != 2'b00) begin
                        pht[{train_pc[6:1], train_history[0]}] <= pht[{train_pc[6:1], train_history[0]}] - 1;
                    end
                end
            end
        end
    end

endmodule