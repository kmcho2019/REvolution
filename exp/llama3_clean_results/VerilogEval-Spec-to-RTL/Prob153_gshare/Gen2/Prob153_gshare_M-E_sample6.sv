module TopModule(
    input  clk,
    input  areset,

    input  predict_valid,
    input  [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input  train_valid,
    input  train_taken,
    input  train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);

    // Stage 1: Prediction
    reg [6:0] branch_history;
    reg [1:0] pht [127:0];
    reg [6:0] pht_index;
    reg predict_taken_reg;
    reg [6:0] predict_history_reg;

    assign pht_index = {predict_pc[6:1] ^ branch_history[6:1]};
    assign predict_taken_reg = (pht[pht_index] == 2'b00 || pht[pht_index] == 2'b01)? 1'b0 : 1'b1;
    assign predict_history_reg = branch_history;

    // Stage 2: Update
    reg [6:0] next_branch_history;
    reg [1:0] next_pht [127:0];

    assign next_branch_history = (predict_valid)? {branch_history[5:0], predict_taken_reg} :
                                (train_valid && train_mispredicted)? train_history : branch_history;

    always @(posedge clk) begin
        if (areset) begin
            branch_history <= 7'b0;
            for (int i = 0; i < 128; i++) begin
                pht[i] <= 2'b01;
            end
        end else begin
            branch_history <= next_branch_history;
            if (train_valid) begin
                if (train_taken) begin
                    if (pht[{train_pc[6:1] ^ train_history[6:1]}] < 2'b11) begin
                        pht[{train_pc[6:1] ^ train_history[6:1]}] <= pht[{train_pc[6:1] ^ train_history[6:1]}] + 1'b1;
                    end
                end else begin
                    if (pht[{train_pc[6:1] ^ train_history[6:1]}] > 2'b00) begin
                        pht[{train_pc[6:1] ^ train_history[6:1]}] <= pht[{train_pc[6:1] ^ train_history[6:1]}] - 1'b1;
                    end
                end
            end
        end
    end

    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

endmodule