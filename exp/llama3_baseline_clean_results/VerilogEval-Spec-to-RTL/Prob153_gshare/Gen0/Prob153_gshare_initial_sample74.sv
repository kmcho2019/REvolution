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
reg [127:0][1:0] pht;

always @(*) begin
    global_history_next = global_history;
    if (train_valid && train_mispredicted) begin
        global_history_next = train_history;
    end else if (predict_valid) begin
        if (predict_taken) begin
            global_history_next = {global_history[5:0], 1'b1};
        end else begin
            global_history_next = {global_history[5:0], 1'b0};
        end
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        pht <= {128{2'b00}};
    end else begin
        global_history <= global_history_next;
        if (train_valid) begin
            reg [6:0] index;
            index = (predict_pc ^ global_history)[6:0];
            if (train_taken) begin
                if (pht[index] != 2'b11) begin
                    pht[index] <= pht[index] + 1;
                end
            end else begin
                if (pht[index] != 2'b00) begin
                    pht[index] <= pht[index] - 1;
                end
            end
        end
    end
end

always @(*) begin
    reg [6:0] index;
    index = (predict_pc ^ global_history)[6:0];
    if (pht[index] >= 2'b10) begin
        predict_taken = 1'b1;
    end else begin
        predict_taken = 1'b0;
    end
    predict_history = global_history;
end

endmodule