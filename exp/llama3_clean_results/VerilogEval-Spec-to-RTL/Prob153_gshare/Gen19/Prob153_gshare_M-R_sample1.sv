module TopModule(
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output reg predict_taken,
    output reg [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

reg [6:0] global_history;
reg [1:0] cache [127:0];

wire [6:0] predict_index;
wire [6:0] train_index;
wire predict_taken_comb;
wire [6:0] predict_history_comb;
wire [6:0] new_global_history_train;
wire [6:0] new_global_history_predict;
wire [1:0] new_cache_train [127:0];

assign predict_index = predict_pc ^ global_history;
assign train_index = train_pc ^ train_history;

assign predict_taken_comb = (cache[predict_index] >= 2'b10);
assign predict_history_comb = global_history;

always @(*) begin
    if (predict_taken_comb) begin
        new_global_history_predict = {global_history[5:0], 1'b1};
    end else begin
        new_global_history_predict = {global_history[5:0], 1'b0};
    end
end

always @(*) begin
    if (train_mispredicted) begin
        new_global_history_train = train_history;
    end else if (train_taken) begin
        new_global_history_train = {train_history[5:0], 1'b1};
    end else begin
        new_global_history_train = {train_history[5:0], 1'b0};
    end
end

always @(*) begin
    for (int i = 0; i < 128; i++) begin
        if (i == train_index && train_valid) begin
            if (train_taken) begin
                if (cache[i] != 2'b11) begin
                    new_cache_train[i] = cache[i] + 1;
                end else begin
                    new_cache_train[i] = cache[i];
                end
            end else begin
                if (cache[i] != 2'b00) begin
                    new_cache_train[i] = cache[i] - 1;
                end else begin
                    new_cache_train[i] = cache[i];
                end
            end
        end else begin
            new_cache_train[i] = cache[i];
        end
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            cache[i] <= 2'b00;
        end
    end else begin
        if (train_valid) begin
            global_history <= new_global_history_train;
            for (int i = 0; i < 128; i++) begin
                cache[i] <= new_cache_train[i];
            end
        end else if (predict_valid) begin
            global_history <= new_global_history_predict;
        end

        if (predict_valid) begin
            predict_taken <= predict_taken_comb;
            predict_history <= predict_history_comb;
        end
    end
end

endmodule