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

reg [6:0] global_history;
reg [1:0] pht [127:0];

always @(*) begin
    predict_history = global_history;
    predict_taken = (pht[{^global_history, predict_pc}] == 2'b11) || (pht[{^global_history, predict_pc}] == 2'b10);
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'd0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'd0;
        end
    end else begin
        if (train_valid) begin
            if (train_mispredicted) begin
                global_history <= train_history;
            end
            if (pht[{^train_history, train_pc}] != 2'b00 && train_taken) begin
                pht[{^train_history, train_pc}] <= pht[{^train_history, train_pc}] + 1;
            end else if (pht[{^train_history, train_pc}] != 2'b11 && !train_taken) begin
                pht[{^train_history, train_pc}] <= pht[{^train_history, train_pc}] - 1;
            end
        end
        if (predict_valid) begin
            global_history <= {global_history[5:0], predict_taken};
        end
    end
end

endmodule