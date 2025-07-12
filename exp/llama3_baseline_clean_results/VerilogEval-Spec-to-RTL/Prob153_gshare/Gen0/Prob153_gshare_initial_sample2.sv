module TopModule(
    input           clk,
    input           areset,

    input           predict_valid,
    input   [6:0]   predict_pc,
    output          predict_taken,
    output  [6:0]   predict_history,

    input           train_valid,
    input           train_taken,
    input           train_mispredicted,
    input   [6:0]   train_history,
    input   [6:0]   train_pc
);

    // Define the PHT
    reg [1:0] pht [127:0];

    // Define the global branch history register
    reg [6:0] global_history;

    // Define the predicted branch direction
    wire predict_taken_w;

    // Hash the pc and global history to get the PHT index
    wire [6:0] index;
    assign index = {predict_pc[6], predict_pc[5:0] ^ global_history};

    // Make a prediction based on the PHT entry
    assign predict_taken_w = (pht[index] > 1) ? 1'b1 : 1'b0;
    assign predict_taken = predict_taken_w;
    assign predict_history = global_history;

    // Update the PHT based on the actual branch outcome
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset the PHT and global history
            for (int i = 0; i < 128; i++) begin
                pht[i] <= 2'b00;
            end
            global_history <= 7'b0;
        end else if (train_valid) begin
            // Update the PHT
            if (train_taken) begin
                if (pht[{train_pc[6], train_pc[5:0] ^ train_history}] < 2'b11) begin
                    pht[{train_pc[6], train_pc[5:0] ^ train_history}] <= pht[{train_pc[6], train_pc[5:0] ^ train_history}] + 1'b1;
                end
            end else begin
                if (pht[{train_pc[6], train_pc[5:0] ^ train_history}] > 2'b00) begin
                    pht[{train_pc[6], train_pc[5:0] ^ train_history}] <= pht[{train_pc[6], train_pc[5:0] ^ train_history}] - 1'b1;
                end
            end

            // Update the global history
            if (train_mispredicted) begin
                global_history <= train_history;
            end else if (predict_valid) begin
                global_history <= {global_history[5:0], predict_taken_w};
            end
        end else if (predict_valid && !train_valid) begin
            // Update the global history
            global_history <= {global_history[5:0], predict_taken_w};
        end
    end

endmodule