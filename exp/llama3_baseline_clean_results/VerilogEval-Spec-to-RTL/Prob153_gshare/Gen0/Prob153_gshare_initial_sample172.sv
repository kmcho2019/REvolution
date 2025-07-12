module TopModule(
    input           clk,
    input           areset,
    input           predict_valid,
    input  [6:0]    predict_pc,
    output          predict_taken,
    output [6:0]    predict_history,
    input           train_valid,
    input           train_taken,
    input           train_mispredicted,
    input  [6:0]    train_history,
    input  [6:0]    train_pc
);

reg [6:0] history;
reg [6:0] history_next;
reg [7:0] pht [127:0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 7'd0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'd0;
        end
    end else begin
        history <= history_next;
        if (train_valid) begin
            pht[{train_pc[6:1], train_history[0]}] <= (train_taken) ? (pht[{train_pc[6:1], train_history[0]} == 2'd3) ? 2'd3 : (pht[{train_pc[6:1], train_history[0]} + 1'd1) : (pht[{train_pc[6:1], train_history[0]} == 2'd0) ? 2'd0 : (pht[{train_pc[6:1], train_history[0]} - 1'd1);
            if (train_mispredicted) begin
                history <= train_history;
            end
        end
        if (predict_valid) begin
            if (train_mispredicted && train_valid) begin
                // Do nothing, let training override prediction
            end else begin
                history_next <= (predict_taken) ? {history[5:0], 1'd1} : {history[5:0], 1'd0};
            end
        end else begin
            history_next <= history;
        end
    end
end

always @(*) begin
    if (predict_valid) begin
        predict_taken = (pht[{predict_pc[6:1], history[0]}] >= 2'd2);
        predict_history = history;
    end else begin
        predict_taken = 1'd0;
        predict_history = 7'd0;
    end
end

endmodule