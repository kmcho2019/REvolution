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

    reg [6:0] branch_history;
    reg [6:0] next_branch_history;
    reg [1:0] pht [127:0];
    reg [6:0] pht_index;

    // Update branch history register
    always @(*) begin
        if (predict_valid) begin
            next_branch_history = {branch_history[5:0], predict_taken};
        end else if (train_valid && train_mispredicted) begin
            next_branch_history = train_history;
        end else begin
            next_branch_history = branch_history;
        end
    end

    // Calculate PHT index
    assign pht_index = {predict_pc[6:1] ^ branch_history[6:1]};

    // Predict branch direction
    always @(*) begin
        if (pht[pht_index] == 2'b00 || pht[pht_index] == 2'b01) begin
            predict_taken = 1'b0;
        end else begin
            predict_taken = 1'b1;
        end
    end

    // Train PHT
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

    // Update predict_history
    always @(*) begin
        predict_history = branch_history;
    end

endmodule