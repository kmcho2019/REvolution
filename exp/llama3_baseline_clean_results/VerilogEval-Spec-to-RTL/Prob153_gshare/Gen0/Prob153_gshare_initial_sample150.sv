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

// Global branch history register
reg [6:0] history;
always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 7'b0;
    end else if (predict_valid) begin
        history <= {history[5:0], predict_taken};
    end else if (train_valid && train_mispredicted) begin
        history <= train_history;
    end
end

// Pattern history table (PHT)
reg [1:0] pht [127:0];
integer i;
always @(posedge clk or posedge areset) begin
    if (areset) begin
        for (i = 0; i < 128; i++) begin
            pht[i] <= 2'b01; // Initialize PHT to weakly taken
        end
    end else if (train_valid) begin
        reg [6:0] index;
        index = train_pc ^ train_history;
        if (train_taken) begin
            if (pht[index] != 2'b11) begin
                pht[index] <= pht[index] + 1;
            end
        end else begin
            if (pht[index] != 2'b00) begin
                pht[index] <= pht[index] - 1;
            end
        end
    end
end

// Prediction logic
always @(posedge clk) begin
    if (predict_valid) begin
        reg [6:0] index;
        index = predict_pc ^ history;
        if (pht[index] == 2'b00 || pht[index] == 2'b01) begin
            predict_taken <= 1'b0;
        end else begin
            predict_taken <= 1'b1;
        end
        predict_history <= history;
    end
end

endmodule