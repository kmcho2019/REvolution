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

reg [6:0] branch_history;
reg [6:0] next_branch_history;
reg [127:0] [1:0] pht;
reg [1:0] predict_pht_value;
reg predict_taken_reg;

always @(*) begin
    // Calculate the index for the PHT
    reg [6:0] index;
    index = branch_history ^ predict_pc;

    // Get the current PHT value
    predict_pht_value = pht[index];

    // Determine the predicted branch direction
    predict_taken_reg = (predict_pht_value == 2'b11 || predict_pht_value == 2'b10);

    // Update the branch history
    next_branch_history = {branch_history[5:0], predict_taken_reg};
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        branch_history <= 7'b0;
        pht <= '0;
    end else begin
        // Update the branch history
        branch_history <= next_branch_history;

        // Train the PHT
        if (train_valid) begin
            reg [6:0] index;
            index = train_history ^ train_pc;
            if (train_taken) begin
                if (pht[index] < 2'b11) begin
                    pht[index] <= pht[index] + 1;
                end
            end else begin
                if (pht[index] > 2'b00) begin
                    pht[index] <= pht[index] - 1;
                end
            end

            // Recover the branch history if a misprediction occurs
            if (train_mispredicted) begin
                branch_history <= train_history;
            end
        end
    end
end

assign predict_taken = predict_taken_reg;
assign predict_history = branch_history;

endmodule