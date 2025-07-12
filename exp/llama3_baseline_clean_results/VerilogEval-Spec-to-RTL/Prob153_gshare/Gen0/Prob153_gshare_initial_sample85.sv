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
reg [127:0][1:0] pht;
reg [6:0] index;
reg predict_taken_reg;

always @(*) begin
    index = predict_pc[6:0] ^ history[6:0];
    if (pht[index] == 2'b00 || pht[index] == 2'b01) begin
        predict_taken_reg = 1'b0;
    end else begin
        predict_taken_reg = 1'b1;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 7'b0;
        pht <= {128{2'b01}};
    end else begin
        if (train_valid && train_mispredicted) begin
            history <= train_history;
        end else if (predict_valid) begin
            history <= {history[5:0], predict_taken_reg};
        end else begin
            history <= history;
        end
        if (train_valid) begin
            if (train_taken) begin
                if (pht[train_pc[6:0] ^ train_history[6:0]] != 2'b11) begin
                    pht[train_pc[6:0] ^ train_history[6:0]] <= pht[train_pc[6:0] ^ train_history[6:0]] + 1'b1;
                end
            end else begin
                if (pht[train_pc[6:0] ^ train_history[6:0]] != 2'b00) begin
                    pht[train_pc[6:0] ^ train_history[6:0]] <= pht[train_pc[6:0] ^ train_history[6:0]] - 1'b1;
                end
            end
        end
    end
end

assign predict_taken = predict_taken_reg;
assign predict_history = history;

endmodule