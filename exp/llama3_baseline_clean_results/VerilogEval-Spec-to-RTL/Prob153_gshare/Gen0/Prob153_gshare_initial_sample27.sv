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

// Define the width of the pattern history table (PHT)
parameter PHT_WIDTH = 128;

// Define the width of the saturating counters
parameter COUNTER_WIDTH = 2;

// Define the width of the global branch history register
parameter HISTORY_WIDTH = 7;

// Define the width of the pc
parameter PC_WIDTH = 7;

// Define the pattern history table (PHT)
reg [COUNTER_WIDTH-1:0] pht [PHT_WIDTH-1:0];

// Define the global branch history register
reg [HISTORY_WIDTH-1:0] history;

// Define the index into the PHT
wire [6:0] index;
assign index = (predict_pc ^ predict_history);

// Define the predicted branch direction
assign predict_taken = (pht[index] >= 2'b10) ? 1'b1 : 1'b0;

// Define the output of the global branch history register during prediction
assign predict_history = history;

// Update the global branch history register during prediction
always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 0;
    end else if (predict_valid) begin
        if (predict_taken) begin
            history <= {history[5:0], 1'b1};
        end else begin
            history <= {history[5:0], 1'b0};
        end
    end
end

// Update the pattern history table (PHT) during training
always @(posedge clk or posedge areset) begin
    if (areset) begin
        for (int i = 0; i < PHT_WIDTH; i++) begin
            pht[i] <= 0;
        end
        history <= 0;
    end else if (train_valid) begin
        wire [6:0] train_index;
        assign train_index = (train_pc ^ train_history);
        if (train_mispredicted) begin
            history <= train_history;
        end
        if (train_taken) begin
            if (pht[train_index] != 2'b11) begin
                pht[train_index] <= pht[train_index] + 1'b1;
            end
        end else begin
            if (pht[train_index] != 2'b00) begin
                pht[train_index] <= pht[train_index] - 1'b1;
            end
        end
    end
end

endmodule