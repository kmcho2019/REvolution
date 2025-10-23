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
reg [6:0] pht_index;
reg [6:0] pht_index_next;

always @(*) begin
    pht_index = (predict_pc ^ global_history) % 128;
    pht_index_next = (train_pc ^ train_history) % 128;
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b00;
        end
    end else begin
        global_history <= global_history_next;
        if (train_valid) begin
            if (train_taken) begin
                if (pht[pht_index_next] != 2'b11) begin
                    pht[pht_index_next] <= pht[pht_index_next] + 1;
                end
            end else begin
                if (pht[pht_index_next] != 2'b00) begin
                    pht[pht_index_next] <= pht[pht_index_next] - 1;
                end
            end
        end
    end
end

always @(*) begin
    if (predict_valid) begin
        predict_taken = (pht[pht_index] >= 2'b02);
        predict_history = global_history;
        if (predict_taken) begin
            global_history_next = {global_history[5:0], 1'b1};
        end else begin
            global_history_next = {global_history[5:0], 1'b0};
        end
    end else begin
        global_history_next = global_history;
    end

    if (train_valid && train_mispredicted) begin
        global_history_next = train_history;
    end
end

endmodule