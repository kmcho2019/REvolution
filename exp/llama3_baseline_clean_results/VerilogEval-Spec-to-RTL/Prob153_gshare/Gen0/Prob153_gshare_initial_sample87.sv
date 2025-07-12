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

    reg [6:0] global_history;
    reg [1:0] prediction_table [127:0];

    assign predict_taken = (prediction_table[{predict_pc[6:1], predict_pc[0]^global_history[6:1]}] == 2'b11) ? 1'b1 : 1'b0;
    assign predict_history = global_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            for (int i = 0; i < 128; i++) begin
                prediction_table[i] <= 2'b01;
            end
        end else if (train_valid) begin
            prediction_table[{train_pc[6:1], train_pc[0]^train_history[6:1]}] <= (train_mispredicted) ? ((prediction_table[{train_pc[6:1], train_pc[0]^train_history[6:1]}] == 2'b00) ? 2'b00 : (prediction_table[{train_pc[6:1], train_pc[0]^train_history[6:1]}] - 1)) : ((prediction_table[{train_pc[6:1], train_pc[0]^train_history[6:1]}] == 2'b11) ? 2'b11 : (prediction_table[{train_pc[6:1], train_pc[0]^train_history[6:1]}] + 1));
            if (train_mispredicted) begin
                global_history <= train_history;
            end else if (predict_valid) begin
                global_history <= {global_history[5:0], predict_taken};
            end
        end else if (predict_valid) begin
            global_history <= {global_history[5:0], predict_taken};
        end
    end
endmodule