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
    reg [6:0] predict_history_reg;
    reg [6:0] train_history_reg;

    reg [1:0] pht [127:0];
    reg [1:0] pht_next [127:0];

    wire [6:0] index;
    wire [6:0] train_index;

    assign index = (predict_pc ^ global_history) % 128;
    assign train_index = (train_pc ^ train_history) % 128;

    always @(*) begin
        global_history_next = global_history;
        predict_taken = 0;
        predict_history_reg = global_history;
        if (predict_valid) begin
            if (pht[index] >= 2'b10) begin
                predict_taken = 1;
            end
            global_history_next = {global_history[5:0], predict_taken};
        end
    end

    always @(*) begin
        pht_next = pht;
        if (train_valid) begin
            if (train_mispredicted) begin
                global_history = train_history;
            end
            if (train_taken) begin
                if (pht[train_index] < 2'b11) begin
                    pht_next[train_index] = pht[train_index] + 1'b1;
                end
            end else begin
                if (pht[train_index] > 2'b00) begin
                    pht_next[train_index] = pht[train_index] - 1'b1;
                end
            end
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            pht <= '{default: 2'b01};
        end else begin
            global_history <= global_history_next;
            pht <= pht_next;
        end
    end

    always @(*) begin
        predict_history = predict_history_reg;
    end

endmodule