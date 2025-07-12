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

// Define the pattern history table (PHT)
reg [1:0] pht [127:0];

// Define the global branch history register
reg [6:0] global_history;

// Define the predicted branch direction and history
reg predict_taken_reg;
reg [6:0] predict_history_reg;

// Hash function to generate the index for the PHT
wire [6:0] index;
assign index = predict_pc ^ global_history;

// Predict the branch direction
always @(*)
begin
    if (pht[index] == 2'b00 || pht[index] == 2'b01)
        predict_taken_reg = 1'b0;
    else
        predict_taken_reg = 1'b1;
end

// Update the global branch history register
always @(posedge clk or posedge areset)
begin
    if (areset)
        global_history <= 7'b0;
    else if (train_mispredicted && train_valid)
        global_history <= train_history;
    else if (predict_valid)
        global_history <= {global_history[5:0], predict_taken_reg};
end

// Update the PHT
always @(posedge clk)
begin
    if (train_valid)
    begin
        if (train_mispredicted)
        begin
            if (pht[train_pc ^ train_history] != 2'b00)
                pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] - 1;
        end
        else if (train_taken)
        begin
            if (pht[train_pc ^ train_history] != 2'b11)
                pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] + 1;
        end
    end
end

// Assign the outputs
assign predict_taken = predict_taken_reg;
assign predict_history = global_history;

endmodule