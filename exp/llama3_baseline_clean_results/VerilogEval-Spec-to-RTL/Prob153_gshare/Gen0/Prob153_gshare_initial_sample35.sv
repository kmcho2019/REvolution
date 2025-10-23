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
    reg [6:0] global_history_next;
    reg [127:0][1:0] pht;
    reg [6:0] pht_index;

    // calculate pht index
    assign pht_index = {predict_pc[6:1]} ^ global_history;

    // prediction logic
    always @(*) begin
        if (pht[pht_index] == 2'b00 || pht[pht_index] == 2'b01) begin
            predict_taken = 1'b0;
        end else begin
            predict_taken = 1'b1;
        end
        predict_history = global_history;
    end

    // training logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            for (int i = 0; i < 128; i++) begin
                pht[i] <= 2'b01;
            end
        end else begin
            if (train_valid) begin
                if (train_mispredicted) begin
                    global_history <= train_history;
                end
                if (train_taken) begin
                    if (pht[{train_pc[6:1]} ^ train_history] != 2'b11) begin
                        pht[{train_pc[6:1]} ^ train_history] <= pht[{train_pc[6:1]} ^ train_history] + 1;
                    end
                end else begin
                    if (pht[{train_pc[6:1]} ^ train_history] != 2'b00) begin
                        pht[{train_pc[6:1]} ^ train_history] <= pht[{train_pc[6:1]} ^ train_history] - 1;
                    end
                end
            end
            if (predict_valid && !train_mispredicted) begin
                if (predict_taken) begin
                    global_history <= {global_history[5:0], 1'b1};
                end else begin
                    global_history <= {global_history[5:0], 1'b0};
                end
            end
        end
    end

endmodule