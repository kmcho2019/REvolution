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
reg [6:0] next_global_history;
reg [127:0][1:0] pht;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        pht <= {128{2'b00}};
    end else begin
        global_history <= next_global_history;
        if (train_valid) begin
            reg [6:0] index;
            index = predict_pc ^ global_history;
            if (train_mispredicted) begin
                if (train_taken)
                    pht[index] <= (pht[index] == 2'b11) ? 2'b11 : pht[index] + 1;
                else
                    pht[index] <= (pht[index] == 2'b00) ? 2'b00 : pht[index] - 1;
            end else begin
                if (train_taken)
                    pht[index] <= (pht[index] == 2'b11) ? 2'b11 : pht[index] + 1;
                else
                    pht[index] <= (pht[index] == 2'b00) ? 2'b00 : pht[index] - 1;
            end
        end
    end
end

always @(*) begin
    next_global_history = global_history;
    if (predict_valid) begin
        if (predict_taken)
            next_global_history = {global_history[5:0], 1'b1};
        else
            next_global_history = {global_history[5:0], 1'b0};
    end
    if (train_valid && train_mispredicted) begin
        next_global_history = train_history;
    end
end

always @(posedge clk) begin
    if (predict_valid) begin
        reg [6:0] index;
        index = predict_pc ^ global_history;
        if (pht[index] == 2'b11 || pht[index] == 2'b10)
            predict_taken <= 1'b1;
        else
            predict_taken <= 1'b0;
        predict_history <= global_history;
    end
end

endmodule