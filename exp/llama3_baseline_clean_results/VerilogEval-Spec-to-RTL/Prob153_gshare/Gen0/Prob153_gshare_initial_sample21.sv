module TopModule(
    input         clk,
    input         areset,
    
    input         predict_valid,
    input  [6:0]  predict_pc,
    output        predict_taken,
    output [6:0]  predict_history,

    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

reg [6:0] history;
reg [6:0] history_next;
reg [6:0] index;
reg [6:0] pht_index;
reg [1:0] pht [127:0];
reg [1:0] pht_next [127:0];

assign index = history ^ predict_pc;
assign pht_index = history ^ train_pc;

always @(*) begin
    predict_taken = (pht[index] > 1);
    predict_history = history;
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
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
    
    if (train_valid) begin
        if (train_taken) begin
            if (pht[pht_index] < 3) begin
                pht_next[pht_index] = pht[pht_index] + 1;
            end
        end else begin
            if (pht[pht_index] > 0) begin
                pht_next[pht_index] = pht[pht_index] - 1;
            end
        end
        
        if (train_mispredicted) begin
            history_next = train_history;
        end
    end
    
    if (predict_valid) begin
        if (predict_taken) begin
            history_next = {history[5:0], 1'b1};
        end else begin
            history_next = {history[5:0], 1'b0};
        end
    end
    
    if (train_valid && train_mispredicted && predict_valid) begin
        history_next = train_history;
    end
end

endmodule