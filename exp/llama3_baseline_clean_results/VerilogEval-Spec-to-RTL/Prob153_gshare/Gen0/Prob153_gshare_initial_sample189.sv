module TopModule (
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

reg [6:0] branch_history;
reg [1:0] pht [127:0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        branch_history <= 7'd0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'd0;
        end
    end else if (train_valid) begin
        if (train_mispredicted) begin
            branch_history <= train_history;
        end
        if (train_taken) begin
            if (pht[{train_pc[6:1], train_history[0]}] < 2'd3) begin
                pht[{train_pc[6:1], train_history[0]}] <= pht[{train_pc[6:1], train_history[0]}] + 1;
            end
        end else begin
            if (pht[{train_pc[6:1], train_history[0]}] > 2'd0) begin
                pht[{train_pc[6:1], train_history[0]}] <= pht[{train_pc[6:1], train_history[0]}] - 1;
            end
        end
    end else if (predict_valid) begin
        if (predict_taken) begin
            branch_history <= {branch_history[5:0], 1'b1};
        end else begin
            branch_history <= {branch_history[5:0], 1'b0};
        end
    end
end

always @(posedge clk) begin
    if (predict_valid) begin
        predict_history <= branch_history;
        predict_taken <= (pht[{predict_pc[6:1], branch_history[0]}] >= 2'd2);
    end
end

endmodule