module TopModule(
    input             clk,
    input             areset,

    input             predict_valid,
    input      [6:0]  predict_pc,
    output            predict_taken,
    output     [6:0]  predict_history,

    input             train_valid,
    input             train_taken,
    input             train_mispredicted,
    input      [6:0]  train_history,
    input      [6:0]  train_pc
);

reg [6:0]            gh;
reg [6:0]            gh_next;
reg [127:0][1:0]      pht;
reg [6:0]            pht_index;
reg [1:0]            pht_value;

assign pht_index = gh[6:0] ^ predict_pc[6:0];

always @(*) begin
    if (predict_valid) begin
        case (pht[pht_index])
            2'b00: begin
                predict_taken = 0;
                gh_next = {gh[5:0], 0};
            end
            2'b01: begin
                predict_taken = 0;
                gh_next = {gh[5:0], 0};
            end
            2'b10: begin
                predict_taken = 1;
                gh_next = {gh[5:0], 1};
            end
            2'b11: begin
                predict_taken = 1;
                gh_next = {gh[5:0], 1};
            end
        endcase
    end else begin
        gh_next = gh;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        gh <= 0;
        pht <= 0;
    end else begin
        gh <= gh_next;
        if (train_valid) begin
            if (train_mispredicted) begin
                gh <= train_history;
            end
            if (train_taken) begin
                if (pht[train_pc[6:0] ^ train_history[6:0]] != 2'b11) begin
                    pht[train_pc[6:0] ^ train_history[6:0]] <= pht[train_pc[6:0] ^ train_history[6:0]] + 2'b01;
                end
            end else begin
                if (pht[train_pc[6:0] ^ train_history[6:0]] != 2'b00) begin
                    pht[train_pc[6:0] ^ train_history[6:0]] <= pht[train_pc[6:0] ^ train_history[6:0]] - 2'b01;
                end
            end
        end
    end
end

assign predict_history = gh;

endmodule