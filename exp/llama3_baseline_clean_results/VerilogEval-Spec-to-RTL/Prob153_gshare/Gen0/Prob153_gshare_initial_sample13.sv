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

reg [6:0] global_history;
reg [6:0] global_history_next;
reg [127:0][1:0] pht;
reg [6:0] index;
reg predict_taken_comb;

always @(*) begin
    // Calculate index by XORing pc and global history
    index = predict_pc ^ global_history;
    // Predict taken based on PHT value
    if (pht[index] == 2'b11 || pht[index] == 2'b10) begin
        predict_taken_comb = 1'b1;
    end else begin
        predict_taken_comb = 1'b0;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'd0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else begin
        global_history <= global_history_next;
        for (int i = 0; i < 128; i++) begin
            if (train_valid && (train_pc ^ train_history) == i) begin
                if (train_taken && !train_mispredicted) begin
                    if (pht[i] != 2'b11) begin
                        pht[i] <= pht[i] + 2'b01;
                    end
                end else if (!train_taken && !train_mispredicted) begin
                    if (pht[i] != 2'b00) begin
                        pht[i] <= pht[i] - 2'b01;
                    end
                end else if (train_mispredicted) begin
                    // Recover global history
                    global_history_next <= train_history;
                    if (train_taken) begin
                        if (pht[i] != 2'b11) begin
                            pht[i] <= pht[i] + 2'b01;
                        end
                    end else begin
                        if (pht[i] != 2'b00) begin
                            pht[i] <= pht[i] - 2'b01;
                        end
                    end
                end
            end
        end
        if (predict_valid) begin
            if (predict_taken_comb) begin
                global_history_next <= {global_history[5:0], 1'b1};
            end else begin
                global_history_next <= {global_history[5:0], 1'b0};
            end
        end else begin
            global_history_next <= global_history;
        end
    end
end

assign predict_taken = predict_taken_comb;
assign predict_history = global_history;

endmodule