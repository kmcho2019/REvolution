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

reg [6:0] global_history;
reg [6:0] pht_index;
reg [1:0] pht_entry;
reg [6:0] recovered_history;

// Initialize PHT
reg [1:0] pht [127:0];

// Initialize PHT with all zeros
initial begin
    for (int i = 0; i < 128; i++) begin
        pht[i] = 2'b00;
    end
end

// Generate PHT index
assign pht_index = (predict_pc ^ global_history)[6:0];

// Prediction logic
always @(*) begin
    if (pht[pht_index] == 2'b11 || pht[pht_index] == 2'b10) begin
        predict_taken = 1'b1;
    end else begin
        predict_taken = 1'b0;
    end
    predict_history = global_history;
end

// Update global history and PHT on positive clock edge
always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b00;
        end
    end else if (train_valid && train_mispredicted) begin
        // Recover global history on misprediction
        global_history <= train_history;
        // Update PHT
        if (train_taken) begin
            if (pht[{train_pc[6:0], train_history[6:0]}[6:0]] == 2'b11) begin
                pht[{train_pc[6:0], train_history[6:0]}[6:0]] <= 2'b11;
            end else begin
                pht[{train_pc[6:0], train_history[6:0]}[6:0]] <= pht[{train_pc[6:0], train_history[6:0]}[6:0]] + 1'b1;
            end
        end else begin
            if (pht[{train_pc[6:0], train_history[6:0]}[6:0]] == 2'b00) begin
                pht[{train_pc[6:0], train_history[6:0]}[6:0]] <= 2'b00;
            end else begin
                pht[{train_pc[6:0], train_history[6:0]}[6:0]] <= pht[{train_pc[6:0], train_history[6:0]}[6:0]] - 1'b1;
            end
        end
    end else if (predict_valid) begin
        // Update global history on prediction
        global_history <= {global_history[5:0], predict_taken};
    end else if (train_valid) begin
        // Update PHT
        if (train_taken) begin
            if (pht[{train_pc[6:0], train_history[6:0]}[6:0]] == 2'b11) begin
                pht[{train_pc[6:0], train_history[6:0]}[6:0]] <= 2'b11;
            end else begin
                pht[{train_pc[6:0], train_history[6:0]}[6:0]] <= pht[{train_pc[6:0], train_history[6:0]}[6:0]] + 1'b1;
            end
        end else begin
            if (pht[{train_pc[6:0], train_history[6:0]}[6:0]] == 2'b00) begin
                pht[{train_pc[6:0], train_history[6:0]}[6:0]] <= 2'b00;
            end else begin
                pht[{train_pc[6:0], train_history[6:0]}[6:0]] <= pht[{train_pc[6:0], train_history[6:0]}[6:0]] - 1'b1;
            end
        end
    end
end

endmodule