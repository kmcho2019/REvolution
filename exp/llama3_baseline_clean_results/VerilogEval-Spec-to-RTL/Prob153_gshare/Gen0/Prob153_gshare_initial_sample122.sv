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
reg [6:0] history_train;
reg [127:0] pht [1:0];

assign predict_taken = (pht[{predict_pc[6:0] ^ history[6:0]}][1] == 2'b11);
assign predict_history = history;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else if (train_valid) begin
        if (train_mispredicted) begin
            history <= train_history;
        end else if (predict_valid) begin
            history <= {history[5:0], predict_taken};
        end

        if (train_taken) begin
            if (pht[{train_pc[6:0] ^ train_history[6:0]}][1] != 2'b11) begin
                pht[{train_pc[6:0] ^ train_history[6:0]}] <= pht[{train_pc[6:0] ^ train_history[6:0]}] + 2'b01;
            end
        end else begin
            if (pht[{train_pc[6:0] ^ train_history[6:0]}][1] != 2'b00) begin
                pht[{train_pc[6:0] ^ train_history[6:0]}] <= pht[{train_pc[6:0] ^ train_history[6:0]}] - 2'b01;
            end
        end
    end else if (predict_valid) begin
        history <= {history[5:0], predict_taken};
    end
end

endmodule