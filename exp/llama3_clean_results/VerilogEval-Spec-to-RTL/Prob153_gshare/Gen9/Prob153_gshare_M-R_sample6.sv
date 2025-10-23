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
reg [6:0] next_global_history;
reg [1:0] cache [127:0];

assign predict_index = predict_pc ^ global_history;
assign train_index = train_pc ^ train_history;

wire predict_taken_comb;
assign predict_taken_comb = (cache[predict_index] == 2'b11 || cache[predict_index] == 2'b10);

always @(*) begin
    next_global_history = global_history;
    if (predict_valid) begin
        if (predict_taken_comb) begin
            next_global_history = {global_history[5:0], 1'b1};
        end else begin
            next_global_history = {global_history[5:0], 1'b0};
        end
    end else if (train_valid && train_mispredicted) begin
        next_global_history = train_history;
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
        global_history <= next_global_history;
        if (predict_valid) begin
            predict_taken <= predict_taken_comb;
            predict_history <= global_history;
        end
        if (train_valid) begin
            if (train_taken) begin
                if (cache[train_index] == 2'b00) begin
                    cache[train_index] <= 2'b01;
                end else if (cache[train_index] == 2'b01) begin
                    cache[train_index] <= 2'b11;
                end
            end else begin
                if (cache[train_index] == 2'b11) begin
                    cache[train_index] <= 2'b10;
                end else if (cache[train_index] == 2'b10) begin
                    cache[train_index] <= 2'b00;
                end
            end
        end
    end
end

endmodule