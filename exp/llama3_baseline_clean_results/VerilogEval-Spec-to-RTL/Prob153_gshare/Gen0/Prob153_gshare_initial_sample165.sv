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

reg [6:0] history;
reg [6:0] history_next;
reg [127:0] [1:0] pht;
reg [127:0] [1:0] pht_next;

assign predict_history = history;
assign predict_taken = (pht[{predict_pc[6:1], history[0]}] > 1);

always @(*) begin
    history_next = history;
    pht_next = pht;
    
    if (train_valid) begin
        if (train_mispredicted) begin
            history_next = train_history;
        end
        pht_next[{train_pc[6:1], train_history[0]}] = (train_taken) ? ((pht[{train_pc[6:1], train_history[0]}] == 2'b11) ? 2'b11 : (pht[{train_pc[6:1], train_history[0]}] + 1)) : ((pht[{train_pc[6:1], train_history[0]}] == 2'b00) ? 2'b00 : (pht[{train_pc[6:1], train_history[0]}] - 1));
    end else if (predict_valid) begin
        history_next = (predict_taken) ? {history[5:0], 1'b1} : {history[5:0], 1'b0};
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 7'b0;
        pht <= {128{2'b01}};
    end else begin
        history <= history_next;
        pht <= pht_next;
    end
end

endmodule