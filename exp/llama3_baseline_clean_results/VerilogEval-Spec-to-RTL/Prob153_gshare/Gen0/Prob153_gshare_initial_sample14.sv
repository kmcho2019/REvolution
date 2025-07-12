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

reg [6:0] ghr; // Global branch history register
reg [1:0] pht [127:0]; // Pattern History Table

// Calculate index for PHT
wire [6:0] predict_index;
assign predict_index = {ghr[6:1], predict_pc[0]};

// Predict branch direction
always @(*) begin
    if (pht[predict_index] == 2'b00 || pht[predict_index] == 2'b01) begin
        predict_taken = 1'b0;
    end else begin
        predict_taken = 1'b1;
    end
end

// Update ghr for predicted branch
always @(posedge clk or posedge areset) begin
    if (areset) begin
        ghr <= 7'b0;
    end else if (predict_valid) begin
        ghr <= {ghr[5:0], predict_taken};
    end else if (train_valid && train_mispredicted) begin
        ghr <= train_history;
    end
end

// Update PHT entry
always @(posedge clk or posedge areset) begin
    if (areset) begin
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b00;
        end
    end else if (train_valid) begin
        wire [6:0] train_index;
        assign train_index = {train_history[6:1], train_pc[0]};
        if (train_taken) begin
            if (pht[train_index] != 2'b11) begin
                pht[train_index] <= pht[train_index] + 1;
            end
        end else begin
            if (pht[train_index] != 2'b00) begin
                pht[train_index] <= pht[train_index] - 1;
            end
        end
    end
end

assign predict_history = ghr;

endmodule