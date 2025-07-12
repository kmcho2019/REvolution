module TopModule (
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
reg [7:0] pht [127:0];
reg [7:0] pht_next [127:0];

always @(*) begin
    predict_history = global_history;
    if (predict_valid) begin
        predict_taken = (pht[{predict_pc[6:1], global_history[0]}] >= 2);
        global_history_next = (predict_taken) ? {global_history[5:0], 1'b1} : {global_history[5:0], 1'b0};
    end else begin
        predict_taken = 1'bx;
        global_history_next = global_history;
    end
end

always @(*) begin
    if (train_valid) begin
        if (train_mispredicted) begin
            global_history_next = train_history;
        end
        if (train_taken) begin
            if (pht[{train_pc[6:1], train_history[0]}] < 3) begin
                pht_next[{train_pc[6:1], train_history[0]}] = pht[{train_pc[6:1], train_history[0]}] + 1;
            end
        end else begin
            if (pht[{train_pc[6:1], train_history[0]}] > 0) begin
                pht_next[{train_pc[6:1], train_history[0]}] = pht[{train_pc[6:1], train_history[0]}] - 1;
            end
        end
    end else begin
        pht_next = pht;
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
        pht <= pht_next;
    end
end

endmodule