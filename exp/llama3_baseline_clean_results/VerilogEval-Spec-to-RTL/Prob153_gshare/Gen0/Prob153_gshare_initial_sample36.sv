module TopModule(
    input               clk,
    input               areset,

    input               predict_valid,
    input       [6:0]   predict_pc,
    output reg          predict_taken,
    output reg  [6:0]   predict_history,

    input               train_valid,
    input               train_taken,
    input               train_mispredicted,
    input       [6:0]   train_history,
    input       [6:0]   train_pc
);

reg [6:0] global_history;
reg [6:0] global_history_next;
reg [127:0][1:0] pht;
reg [127:0][1:0] pht_next;

integer i;

always @(*) begin
    pht_next = pht;
    global_history_next = global_history;

    if (train_valid) begin
        reg [6:0] index;
        index = train_pc ^ train_history;
        if (train_taken) begin
            if (pht[index] < 3) begin
                pht_next[index] = pht[index] + 1;
            end
        end else begin
            if (pht[index] > 0) begin
                pht_next[index] = pht[index] - 1;
            end
        end
        if (train_mispredicted) begin
            global_history_next = train_history;
        end
    end

    if (predict_valid) begin
        global_history_next = {global_history[5:0], predict_taken};
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        pht <= {128{2'b00}};
    end else begin
        global_history <= global_history_next;
        pht <= pht_next;
    end
end

always @(*) begin
    if (predict_valid) begin
        reg [6:0] index;
        index = predict_pc ^ global_history;
        if (pht[index] >= 2) begin
            predict_taken = 1'b1;
        end else begin
            predict_taken = 1'b0;
        end
        predict_history = global_history;
    end
end

endmodule