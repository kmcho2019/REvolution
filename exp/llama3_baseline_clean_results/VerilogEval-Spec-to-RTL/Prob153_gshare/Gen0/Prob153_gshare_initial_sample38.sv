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

reg [6:0] history_reg;
reg [6:0] history_reg_next;
reg [127:0] pht [1:0]; // 128-entry table of two-bit saturating counters
reg [127:0] pht_next [1:0];

assign predict_taken = (pht[predict_pc[6]^history_reg[6]][predict_pc[5:0]^history_reg[5:0]] == 2'b11) ? 1'b1 : 1'b0;
assign predict_history = history_reg;

always @(*) begin
    history_reg_next = history_reg;
    if (predict_valid) begin
        if (pht[predict_pc[6]^history_reg[6]][predict_pc[5:0]^history_reg[5:0]] == 2'b11) begin
            history_reg_next = {history_reg[5:0], 1'b1};
        end else begin
            history_reg_next = {history_reg[5:0], 1'b0};
        end
    end

    if (train_valid) begin
        if (train_mispredicted) begin
            history_reg_next = train_history;
        end
    end
end

always @(*) begin
    pht_next = pht;
    if (train_valid) begin
        if (train_taken) begin
            if (pht[train_pc[6]^train_history[6]][train_pc[5:0]^train_history[5:0]] != 2'b11) begin
                pht_next[train_pc[6]^train_history[6]][train_pc[5:0]^train_history[5:0]] = pht[train_pc[6]^train_history[6]][train_pc[5:0]^train_history[5:0]] + 1;
            end
        end else begin
            if (pht[train_pc[6]^train_history[6]][train_pc[5:0]^train_history[5:0]] != 2'b00) begin
                pht_next[train_pc[6]^train_history[6]][train_pc[5:0]^train_history[5:0]] = pht[train_pc[6]^train_history[6]][train_pc[5:0]^train_history[5:0]] - 1;
            end
        end
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history_reg <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else begin
        history_reg <= history_reg_next;
        pht <= pht_next;
    end
end

endmodule