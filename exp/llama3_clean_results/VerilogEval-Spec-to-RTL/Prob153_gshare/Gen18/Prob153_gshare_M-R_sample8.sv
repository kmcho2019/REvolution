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

reg [1:0] pht [127:0];
reg [6:0] history;
reg [6:0] next_history;

wire [6:0] predict_index;
wire [6:0] train_index;
wire predict_taken_comb;
wire [6:0] predict_history_comb;
wire [1:0] pht_update;
wire [6:0] history_update;

assign predict_index = {predict_pc[6:1], predict_pc[0] ^ history[0]};
assign train_index = {train_pc[6:1], train_pc[0] ^ train_history[0]};
assign predict_taken_comb = (pht[predict_index] >= 2'b10) ? 1'b1 : 1'b0;
assign predict_history_comb = history;

always @(*) begin
    next_history = history;
    if (train_valid && train_mispredicted) begin
        next_history = train_history;
    end else if (predict_valid && !train_valid) begin
        next_history = {history[5:0], predict_taken_comb};
    end
end

always @(*) begin
    pht_update = pht[train_index];
    if (train_valid) begin
        if (train_taken) begin
            if (pht[train_index] != 2'b11) begin
                pht_update = pht[train_index] + 1;
            end
        end else begin
            if (pht[train_index] != 2'b00) begin
                pht_update = pht[train_index] - 1;
            end
        end
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 7'b0;
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else begin
        history <= next_history;
        predict_taken <= predict_taken_comb;
        predict_history <= predict_history_comb;
        if (train_valid) begin
            pht[train_index] <= pht_update;
        end
    end
end

endmodule