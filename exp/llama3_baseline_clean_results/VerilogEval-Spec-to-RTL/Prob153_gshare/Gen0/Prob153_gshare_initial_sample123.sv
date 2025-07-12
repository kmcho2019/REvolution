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
reg [1:0] pht [127:0];
reg [1:0] pht_next [127:0];

always @(*) begin
    global_history_next = global_history;
    for (int i = 0; i < 128; i++) begin
        pht_next[i] = pht[i];
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else begin
        global_history <= global_history_next;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= pht_next[i];
        end
    end
end

always @(*) begin
    reg [6:0] predict_index;
    reg [6:0] train_index;
    reg predict_taken_temp;
    reg [6:0] predict_history_temp;

    predict_index = {predict_pc[6:1], 1'b0} ^ global_history;
    train_index = {train_pc[6:1], 1'b0} ^ train_history;

    if (pht[predict_index] == 2'b00 || pht[predict_index] == 2'b01) begin
        predict_taken_temp = 1'b0;
    end else begin
        predict_taken_temp = 1'b1;
    end

    predict_history_temp = global_history;

    if (predict_valid) begin
        if (predict_taken_temp) begin
            global_history_next = {global_history[5:0], 1'b1};
        end else begin
            global_history_next = {global_history[5:0], 1'b0};
        end
    end

    if (train_valid) begin
        if (train_taken) begin
            if (pht[train_index] != 2'b11) begin
                pht_next[train_index] = pht[train_index] + 1;
            end
        end else begin
            if (pht[train_index] != 2'b00) begin
                pht_next[train_index] = pht[train_index] - 1;
            end
        end

        if (train_mispredicted) begin
            global_history_next = train_history;
        end
    end

    predict_taken = predict_taken_temp;
    predict_history = predict_history_temp;
end

endmodule