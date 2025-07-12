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

integer i;

always @(*) begin
    global_history_next = global_history;
    for (i = 0; i < 128; i++) begin
        pht_next[i] = pht[i];
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 0;
        for (i = 0; i < 128; i++) begin
            pht[i] <= 0;
        end
    end else begin
        global_history <= global_history_next;
        for (i = 0; i < 128; i++) begin
            pht[i] <= pht_next[i];
        end
    end
end

always @(*) begin
    predict_taken = 0;
    predict_history = global_history;
    if (predict_valid) begin
        reg [6:0] index;
        index = predict_pc ^ global_history;
        if (pht[index] == 2'b11 || pht[index] == 2'b10) begin
            predict_taken = 1;
        end
        if (predict_taken) begin
            global_history_next = {global_history[5:0], 1'b1};
        end else begin
            global_history_next = {global_history[5:0], 1'b0};
        end
    end
end

always @(*) begin
    if (train_valid) begin
        reg [6:0] index;
        index = train_pc ^ train_history;
        if (train_taken) begin
            if (pht[index] != 2'b11) begin
                pht_next[index] = pht[index] + 1;
            end
        end else begin
            if (pht[index] != 2'b00) begin
                pht_next[index] = pht[index] - 1;
            end
        end
        if (train_mispredicted) begin
            global_history_next = train_history;
        end
    end
end

endmodule