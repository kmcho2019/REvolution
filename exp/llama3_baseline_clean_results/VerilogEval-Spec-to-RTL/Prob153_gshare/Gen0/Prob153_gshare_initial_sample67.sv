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

reg [6:0] global_history;
reg [6:0] global_history_next;

reg [7:0] pht_index;
reg [1:0] pht_entry;
reg [1:0] pht_entry_next;

reg [6:0] pht[127:0];

always @(*) begin
    pht_index = predict_pc ^ global_history;
    pht_entry = pht[pht_index];
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b00;
        end
    end else begin
        global_history <= global_history_next;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= pht[i];
        end

        if (train_valid) begin
            pht[train_pc ^ train_history] <= (train_taken) ? (pht[train_pc ^ train_history] + 1'b1) : (pht[train_pc ^ train_history] - 1'b1);
            if (train_mispredicted) begin
                global_history_next <= train_history;
            end else begin
                global_history_next <= (global_history << 1) | train_taken;
            end
        end else if (predict_valid) begin
            global_history_next <= (global_history << 1) | (pht_entry > 2'b01);
        end else begin
            global_history_next <= global_history;
        end

        if (pht[train_pc ^ train_history] > 2'b11) begin
            pht[train_pc ^ train_history] <= 2'b11;
        end else if (pht[train_pc ^ train_history] < 2'b00) begin
            pht[train_pc ^ train_history] <= 2'b00;
        end
    end
end

always @(*) begin
    predict_taken = (pht_entry > 2'b01);
    predict_history = global_history;
end

endmodule