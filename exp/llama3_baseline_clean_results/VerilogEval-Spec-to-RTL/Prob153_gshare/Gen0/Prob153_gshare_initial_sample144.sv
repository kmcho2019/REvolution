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

reg [6:0] history;
reg [6:0] history_next;
reg [7:0] pht [127:0];
reg [7:0] pht_next [127:0];

always @(*) begin
    history_next = history;
    if (predict_valid) begin
        history_next = {history[5:0], predict_taken};
    end else if (train_valid && train_mispredicted) begin
        history_next = train_history;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2;
        end
    end else begin
        history <= history_next;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= pht_next[i];
        end
    end
end

always @(*) begin
    predict_taken = 0;
    predict_history = history;
    if (predict_valid) begin
        reg [6:0] index;
        index = {predict_pc[6:1], history[0]};
        if (pht[index] >= 2) begin
            predict_taken = 1;
        end
    end
end

always @(*) begin
    for (int i = 0; i < 128; i++) begin
        pht_next[i] = pht[i];
    end
    if (train_valid) begin
        reg [6:0] index;
        index = {train_pc[6:1], train_history[0]};
        if (train_taken) begin
            if (pht[index] < 3) begin
                pht_next[index] = pht[index] + 1;
            end
        end else begin
            if (pht[index] > 0) begin
                pht_next[index] = pht[index] - 1;
            end
        end
    end
end

endmodule