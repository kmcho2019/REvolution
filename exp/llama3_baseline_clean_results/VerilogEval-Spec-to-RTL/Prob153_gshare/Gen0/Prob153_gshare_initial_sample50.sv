module TopModule (
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
reg [6:0] predict_history_reg;
reg [6:0] train_history_reg;

reg [7:0] pht_index;
reg [1:0] pht_value;
reg [1:0] pht_value_next;

reg [6:0] pht [127:0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        predict_history_reg <= 7'b0;
        train_history_reg <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else begin
        if (predict_valid) begin
            predict_history_reg <= global_history;
            pht_index <= {predict_pc, global_history} ^ 7'b1;
            pht_value <= pht[pht_index];
            if (pht_value == 2'b11 || pht_value == 2'b10) begin
                predict_taken <= 1'b1;
            end else begin
                predict_taken <= 1'b0;
            end
        end

        if (train_valid) begin
            train_history_reg <= train_history;
            if (train_mispredicted) begin
                global_history <= train_history;
            end
        end

        if (train_valid && (train_mispredicted || train_taken)) begin
            pht_index <= {train_pc, train_history} ^ 7'b1;
            if (train_mispredicted) begin
                if (pht[pht_index] != 2'b00) begin
                    pht_value_next <= pht[pht_index] - 1;
                end else begin
                    pht_value_next <= pht[pht_index];
                end
            end else if (train_taken) begin
                if (pht[pht_index] != 2'b11) begin
                    pht_value_next <= pht[pht_index] + 1;
                end else begin
                    pht_value_next <= pht[pht_index];
                end
            end
        end else begin
            pht_value_next <= pht[pht_index];
        end

        global_history <= (predict_valid && predict_taken) ? {global_history[5:0], 1'b1} : global_history;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= (i == pht_index) ? pht_value_next : pht[i];
        end
    end
end

assign predict_history = predict_history_reg;

endmodule