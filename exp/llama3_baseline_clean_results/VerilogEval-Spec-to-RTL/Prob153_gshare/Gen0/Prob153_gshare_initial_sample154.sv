module TopModule (
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

reg [127:0][1:0] pht;
reg [127:0][1:0] pht_next;

wire [6:0] index;
assign index = global_history ^ predict_pc;

wire [1:0] pht_out;
assign pht_out = pht[index];

always @(*) begin
    global_history_next = global_history;
    if (predict_valid) begin
        if (pht_out == 2'b11 || pht_out == 2'b10)
            predict_taken = 1'b1;
        else
            predict_taken = 1'b0;
        predict_history = global_history;
        if (predict_taken)
            global_history_next = {global_history[5:0], 1'b1};
        else
            global_history_next = {global_history[5:0], 1'b0};
    end
    if (train_valid) begin
        if (train_mispredicted) begin
            global_history_next = train_history;
        end
        if (train_taken) begin
            if (pht[train_pc ^ train_history] == 2'b00)
                pht_next[train_pc ^ train_history] = 2'b01;
            else if (pht[train_pc ^ train_history] == 2'b01)
                pht_next[train_pc ^ train_history] = 2'b10;
            else if (pht[train_pc ^ train_history] == 2'b10)
                pht_next[train_pc ^ train_history] = 2'b11;
        end
        else begin
            if (pht[train_pc ^ train_history] == 2'b11)
                pht_next[train_pc ^ train_history] = 2'b10;
            else if (pht[train_pc ^ train_history] == 2'b10)
                pht_next[train_pc ^ train_history] = 2'b01;
            else if (pht[train_pc ^ train_history] == 2'b01)
                pht_next[train_pc ^ train_history] = 2'b00;
        end
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        pht <= {128{2'b00}};
    end
    else begin
        global_history <= global_history_next;
        pht <= pht_next;
    end
end

endmodule