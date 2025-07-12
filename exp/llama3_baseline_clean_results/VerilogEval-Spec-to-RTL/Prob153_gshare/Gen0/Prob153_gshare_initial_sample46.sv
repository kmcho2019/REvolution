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
reg [1:0] pht [0:127];

always @(*) begin
    predict_taken = 0;
    predict_history = global_branch_history;
    if (predict_valid) begin
        reg [6:0] index;
        index = {predict_pc[6:1], global_branch_history[0]};
        if (pht[index] == 2'b11 || pht[index] == 2'b10)
            predict_taken = 1;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_branch_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else if (train_valid) begin
        reg [6:0] index;
        index = {train_pc[6:1], train_history[0]};
        if (train_taken) begin
            if (pht[index] < 2'b11)
                pht[index] <= pht[index] + 1'b1;
        end else begin
            if (pht[index] > 2'b00)
                pht[index] <= pht[index] - 1'b1;
        end
        if (train_mispredicted)
            global_branch_history <= train_history;
    end else if (predict_valid) begin
        global_branch_history[0] <= predict_taken;
        for (int i = 1; i < 7; i++) begin
            global_branch_history[i] <= global_branch_history[i-1];
        end
    end
end

endmodule