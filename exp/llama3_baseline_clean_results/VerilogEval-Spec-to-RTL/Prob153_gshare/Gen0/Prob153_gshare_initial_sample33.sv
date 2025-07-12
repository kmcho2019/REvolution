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

reg [6:0] global_branch_history;
reg [1:0] pht [127:0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_branch_history <= 0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 0;
        end
    end else begin
        if (train_valid) begin
            if (train_mispredicted) begin
                global_branch_history <= train_history;
            end
            if (train_pc[6:0] == 7'b0) begin
                pht[0] <= train_taken ? (pht[0] + 1) : (pht[0] - 1);
            end else begin
                pht[{train_pc[6:1], train_pc[0] ^ global_branch_history[0]}] <= train_taken ? (pht[{train_pc[6:1], train_pc[0] ^ global_branch_history[0]}] + 1) : (pht[{train_pc[6:1], train_pc[0] ^ global_branch_history[0]}] - 1);
            end
        end
        if (predict_valid) begin
            global_branch_history <= {global_branch_history[5:0], predict_taken};
        end
    end
end

always @(*) begin
    if (predict_pc[6:0] == 7'b0) begin
        predict_taken = (pht[0] >= 2);
    end else begin
        predict_taken = (pht[{predict_pc[6:1], predict_pc[0] ^ global_branch_history[0]}] >= 2);
    end
    predict_history = global_branch_history;
end

endmodule