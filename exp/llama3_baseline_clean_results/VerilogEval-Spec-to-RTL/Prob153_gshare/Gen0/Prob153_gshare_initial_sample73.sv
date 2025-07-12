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

    reg [6:0] global_branch_history;
    reg [6:0] next_global_branch_history;

    reg [6:0] pht_index;
    reg [1:0] pht_entry;

    reg [127:0] pht [1:0];

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_branch_history <= 0;
            for (int i = 0; i < 128; i++) begin
                pht[i] <= 2'b01;
            end
        end else begin
            if (train_valid && train_mispredicted) begin
                global_branch_history <= train_history;
            end else if (predict_valid) begin
                global_branch_history <= next_global_branch_history;
            end

            if (train_valid) begin
                pht[pht_index] <= (pht[pht_index] == 2'b00 && train_taken) ? 2'b01 :
                                  (pht[pht_index] == 2'b11 && !train_taken) ? 2'b10 :
                                  pht[pht_index] + (train_taken ? 1 : -1);
            end
        end
    end

    always @(*) begin
        pht_index = predict_pc[6:0] ^ global_branch_history;
        pht_entry = pht[pht_index];
        predict_taken = (pht_entry == 2'b11 || pht_entry == 2'b10);
        predict_history = global_branch_history;
        next_global_branch_history = global_branch_history;
        if (predict_valid && predict_taken) begin
            next_global_branch_history = {global_branch_history[5:0], 1'b1};
        end else if (predict_valid && !predict_taken) begin
            next_global_branch_history = {global_branch_history[5:0], 1'b0};
        end
    end

endmodule