module TopModule(
    input         clk,
    input         areset,

    input         predict_valid,
    input  [6:0]   predict_pc,
    output        predict_taken,
    output [6:0]  predict_history,

    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

// Pattern History Table (PHT)
reg [1:0] pht [127:0];

// Global Branch History Register
reg [6:0] gbr;

// Prediction logic
always @(*) begin
    predict_taken = (pht[{predict_pc[6:1], gbr[6:3]}] >= 2) ? 1'b1 : 1'b0;
    predict_history = gbr;
end

// Update gbr on prediction
always @(posedge clk or posedge areset) begin
    if (areset) begin
        gbr <= 7'b0;
    end else if (predict_valid) begin
        gbr <= {gbr[5:0], predict_taken};
    end
end

// Training logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
        gbr <= 7'b0;
    end else if (train_valid) begin
        if (train_taken) begin
            if (pht[{train_pc[6:1], train_history[6:3]}] != 2'b11) begin
                pht[{train_pc[6:1], train_history[6:3]}] <= pht[{train_pc[6:1], train_history[6:3]}] + 1'b1;
            end
        end else begin
            if (pht[{train_pc[6:1], train_history[6:3]}] != 2'b00) begin
                pht[{train_pc[6:1], train_history[6:3]}] <= pht[{train_pc[6:1], train_history[6:3]}] - 1'b1;
            end
        end
        if (train_mispredicted) begin
            gbr <= train_history;
        end
    end
end

endmodule