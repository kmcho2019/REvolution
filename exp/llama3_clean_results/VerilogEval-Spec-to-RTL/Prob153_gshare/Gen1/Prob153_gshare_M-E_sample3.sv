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

// Fast path predictor
reg [6:0] ghr;
reg [6:0] ghr_next;
reg [127:0] [1:0] pht;
reg [127:0] [1:0] pht_next;

// Slow path predictor (perceptron-based)
reg [3:0] perceptron_weights [127:0];
reg [3:0] perceptron_bias;
reg [6:0] slow_path_history;

always @(*) begin
    ghr_next = ghr;
    if (train_valid) begin
        if (train_mispredicted) begin
            ghr_next = train_history;
        end
    end else if (predict_valid) begin
        ghr_next = {ghr[5:0], predict_taken};
    end
end

always @(*) begin
    pht_next = pht;
    if (train_valid) begin
        reg [6:0] index;
        index = (predict_pc ^ ghr)[6:0];
        if (train_taken) begin
            if (pht[index]!= 2'b11) begin
                pht_next[index] = pht[index] + 1'b1;
            end
        end else begin
            if (pht[index]!= 2'b00) begin
                pht_next[index] = pht[index] - 1'b1;
            end
        end
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        ghr <= 7'b0;
        pht <= {128{2'b01}};
    end else begin
        ghr <= ghr_next;
        pht <= pht_next;
    end
end

// Slow path predictor update
always @(posedge clk) begin
    if (train_valid) begin
        reg [6:0] index;
        index = (train_pc ^ train_history)[6:0];
        if (train_taken) begin
            perceptron_weights[index] <= perceptron_weights[index] + 1;
        end else begin
            perceptron_weights[index] <= perceptron_weights[index] - 1;
        end
    end
end

// Prediction logic
always @(*) begin
    reg [6:0] index;
    index = (predict_pc ^ ghr)[6:0];
    if (pht[index] == 2'b11 || pht[index] == 2'b00) begin
        // Fast path prediction
        predict_taken = pht[index][1];
    end else begin
        // Slow path prediction
        predict_taken = (perceptron_weights[index] + perceptron_bias) > 4;
    end
    predict_history = ghr;
end

endmodule