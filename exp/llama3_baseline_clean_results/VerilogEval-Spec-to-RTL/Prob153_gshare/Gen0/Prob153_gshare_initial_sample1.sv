module TopModule (
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

// Internal signals
reg [6:0] history;
reg [6:0] next_history;
reg [127:0][1:0] pht;
reg [6:0] index;

// Calculate the index for the PHT
assign index = predict_pc ^ history;

// Prediction logic
always @(*) begin
    if (pht[index] == 2'b00 || pht[index] == 2'b01) begin
        predict_taken = 1'b0;
    end else begin
        predict_taken = 1'b1;
    end
    predict_history = history;
end

// Update the branch history register
always @(*) begin
    if (predict_valid) begin
        if (predict_taken) begin
            next_history = {history[5:0], 1'b1};
        end else begin
            next_history = {history[5:0], 1'b0};
        end
    end else if (train_valid && train_mispredicted) begin
        next_history = train_history;
    end else begin
        next_history = history;
    end
end

// Training logic
always @(*) begin
    if (train_valid) begin
        if (train_taken) begin
            if (pht[train_pc ^ train_history] != 2'b11) begin
                pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] + 1;
            end
        end else begin
            if (pht[train_pc ^ train_history] != 2'b00) begin
                pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] - 1;
            end
        end
    end
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 7'b0;
        pht <= {128{2'b00}};
    end else begin
        history <= next_history;
        // No need to assign pht here, it's already assigned in the training logic
    end
end

endmodule