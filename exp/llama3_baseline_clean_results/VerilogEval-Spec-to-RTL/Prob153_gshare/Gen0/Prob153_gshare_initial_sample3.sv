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
    reg [6:0] prev_branch_history;
    reg [7:0] prediction_history_table [127:0];

    assign predict_history = branch_history;
    assign predict_taken = (prediction_history_table[{predict_pc[6:1], predict_pc[0] ^ branch_history[6:0]}] >= 2);

    always @(*) begin
        prev_branch_history = branch_history;
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            branch_history <= 7'd0;
            for (int i = 0; i < 128; i++) begin
                prediction_history_table[i] <= 2'd0;
            end
        end else begin
            if (train_valid) begin
                if (train_mispredicted) begin
                    branch_history <= prev_branch_history;
                end
                if (train_taken) begin
                    if (prediction_history_table[{train_pc[6:1], train_pc[0] ^ train_history[6:0]}] < 3) begin
                        prediction_history_table[{train_pc[6:1], train_pc[0] ^ train_history[6:0]}] <= prediction_history_table[{train_pc[6:1], train_pc[0] ^ train_history[6:0]}] + 1;
                    end
                end else begin
                    if (prediction_history_table[{train_pc[6:1], train_pc[0] ^ train_history[6:0]}] > 0) begin
                        prediction_history_table[{train_pc[6:1], train_pc[0] ^ train_history[6:0]}] <= prediction_history_table[{train_pc[6:1], train_pc[0] ^ train_history[6:0]}] - 1;
                    end
                end
            end
            if (predict_valid) begin
                if (predict_taken) begin
                    branch_history[6:0] <= {branch_history[5:0], 1'b1};
                end else begin
                    branch_history[6:0] <= {branch_history[5:0], 1'b0};
                end
            end
        end
    end
endmodule