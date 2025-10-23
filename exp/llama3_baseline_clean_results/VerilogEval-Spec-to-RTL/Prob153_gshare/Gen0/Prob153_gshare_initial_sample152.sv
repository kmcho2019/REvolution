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
reg [6:0] global_history;
always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 0;
    end else if (train_mispredicted && train_valid) begin
        global_history <= train_history;
    end else if (predict_valid) begin
        global_history <= {global_history[5:0], predict_taken};
    end
end

// Pattern history table (PHT)
reg [1:0] pht [127:0];
integer i;
always @(posedge clk) begin
    if (train_valid) begin
        reg [6:0] index;
        index = predict_pc ^ global_history;
        if (index >= 128) begin
            $display("Index out of range: %d", index);
        end else begin
            if (train_taken) begin
                if (pht[index]!= 2'b11) begin
                    pht[index] <= pht[index] + 1'b1;
                end
            end else begin
                if (pht[index]!= 2'b00) begin
                    pht[index] <= pht[index] - 1'b1;
                end
            end
        end
    end
end

// Prediction logic
always @(posedge clk) begin
    if (predict_valid) begin
        reg [6:0] index;
        index = predict_pc ^ global_history;
        if (index >= 128) begin
            $display("Index out of range: %d", index);
            predict_taken <= 1'b0;
        end else begin
            predict_taken <= (pht[index] == 2'b11 || pht[index] == 2'b10);
        end
        predict_history <= global_history;
    end
end

endmodule