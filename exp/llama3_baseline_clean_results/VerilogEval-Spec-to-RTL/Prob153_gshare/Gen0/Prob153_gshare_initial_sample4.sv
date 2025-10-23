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
reg [6:0] next_global_history;

reg [7:0] pht [127:0];  // 128-entry table of two-bit saturating counters

assign predict_history = global_history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 0;
    end else begin
        global_history <= next_global_history;
    end
end

always @(*) begin
    next_global_history = global_history;
    if (train_valid && train_mispredicted) begin
        next_global_history = train_history;
    end else if (predict_valid) begin
        next_global_history = {global_history[5:0], predict_taken};
    end
end

assign predict_taken = (pht[{predict_pc[6:1], predict_history[0]}] >= 2'b10);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b00;
        end
    end else if (train_valid) begin
        if (train_taken && train_mispredicted) begin
            pht[{train_pc[6:1], train_history[0]}] <= pht[{train_pc[6:1], train_history[0]}] + 2'b01;
        end else if (!train_taken && train_mispredicted) begin
            pht[{train_pc[6:1], train_history[0]}] <= pht[{train_pc[6:1], train_history[0]}] - 2'b01;
        end
        if (pht[{train_pc[6:1], train_history[0]}] > 2'b11) begin
            pht[{train_pc[6:1], train_history[0]}] <= 2'b11;
        end
        if (pht[{train_pc[6:1], train_history[0]}] < 2'b00) begin
            pht[{train_pc[6:1], train_history[0]}] <= 2'b00;
        end
    end
end

endmodule