module TopModule (
    input         clk,
    input         areset,

    input         predict_valid,
    input  [6:0]   predict_pc,
    output        predict_taken,
    output [6:0]  predict_history,

    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]   train_history,
    input  [6:0]   train_pc
);

reg [6:0] history_reg;
reg [6:0] history_reg_next;
reg [127:0] [1:0] pht;

assign predict_taken = (pht[{predict_pc[6:0], history_reg[6:0]}] > 1'b1);
assign predict_history = history_reg;

always @(*) begin
    history_reg_next = history_reg;
    if (predict_valid) begin
        if (predict_taken)
            history_reg_next = {history_reg[5:0], 1'b1};
        else
            history_reg_next = {history_reg[5:0], 1'b0};
    end
    if (train_valid) begin
        if (train_mispredicted) begin
            history_reg_next = train_history;
        end
        if (train_taken)
            pht[{train_pc[6:0], train_history[6:0]}] = (pht[{train_pc[6:0], train_history[6:0]}] + 2'b01);
        else if (pht[{train_pc[6:0], train_history[6:0]}] > 2'b00)
            pht[{train_pc[6:0], train_history[6:0]}] = (pht[{train_pc[6:0], train_history[6:0]}] - 2'b01);
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history_reg <= 7'b0;
        pht <= {128{2'b01}};
    end else begin
        history_reg <= history_reg_next;
    end
end

endmodule