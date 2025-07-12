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

reg [6:0] history;
reg [6:0] history_next;

reg [7:0] pht [0:127];
reg [7:0] pht_next [0:127];

wire [6:0] pht_index;
assign pht_index = history ^ predict_pc;

wire [1:0] pht_out;
assign pht_out = pht[pht_index];

assign predict_taken = (pht_out == 2'b11) | (pht_out == 2'b10);
assign predict_history = history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b00;
        end
    end else begin
        history <= history_next;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= pht_next[i];
        end
    end
end

always @(*) begin
    history_next = history;
    for (int i = 0; i < 128; i++) begin
        pht_next[i] = pht[i];
    end

    if (predict_valid) begin
        history_next[0] = predict_taken;
        for (int i = 1; i < 7; i++) begin
            history_next[i] = history[i-1];
        end
    end

    if (train_valid) begin
        if (train_mispredicted) begin
            history_next = train_history;
        end

        if (train_taken) begin
            if (pht[train_pc ^ train_history] != 2'b11) begin
                pht_next[train_pc ^ train_history] = pht[train_pc ^ train_history] + 2'b01;
            end
        end else begin
            if (pht[train_pc ^ train_history] != 2'b00) begin
                pht_next[train_pc ^ train_history] = pht[train_pc ^ train_history] - 2'b01;
            end
        end
    end
end

endmodule