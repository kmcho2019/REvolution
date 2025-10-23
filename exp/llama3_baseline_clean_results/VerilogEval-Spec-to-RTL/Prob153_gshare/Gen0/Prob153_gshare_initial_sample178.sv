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

reg [6:0] history;
reg [6:0] predict_history_reg;
reg [7:0] pht_index;
reg [1:0] pht_entry;
reg predict_taken_reg;

// Initialize the PHT with all zeros
reg [1:0] pht [127:0];

// Reset the module asynchronously
always @(posedge areset) begin
    history <= 7'b0;
    predict_history_reg <= 7'b0;
    for (int i = 0; i < 128; i++) begin
        pht[i] <= 2'b00;
    end
end

// Update the PHT and history register at the positive edge of the clock
always @(posedge clk) begin
    if (train_valid) begin
        // Update the PHT
        pht_index <= (train_pc ^ train_history) % 128;
        if (train_taken) begin
            if (pht[pht_index] == 2'b11) begin
                pht[pht_index] <= 2'b11;
            end else begin
                pht[pht_index] <= pht[pht_index] + 1;
            end
        end else begin
            if (pht[pht_index] == 2'b00) begin
                pht[pht_index] <= 2'b00;
            end else begin
                pht[pht_index] <= pht[pht_index] - 1;
            end
        end

        // Update the history register if mispredicted
        if (train_mispredicted) begin
            history <= train_history;
        end
    end

    if (predict_valid) begin
        // Update the history register
        if (!train_valid || !train_mispredicted) begin
            history <= {history[5:0], predict_taken_reg};
        end
    end

    // Make a prediction
    if (predict_valid) begin
        pht_index <= (predict_pc ^ history) % 128;
        pht_entry <= pht[pht_index];
        if (pht_entry >= 2'b10) begin
            predict_taken_reg <= 1'b1;
        end else begin
            predict_taken_reg <= 1'b0;
        end
        predict_history_reg <= history;
    end
end

assign predict_taken = predict_taken_reg;
assign predict_history = predict_history_reg;

endmodule