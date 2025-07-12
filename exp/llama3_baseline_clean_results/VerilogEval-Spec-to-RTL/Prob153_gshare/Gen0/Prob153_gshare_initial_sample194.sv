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

    // Initialize the global branch history register
    reg [6:0] global_history;
    reg [6:0] next_global_history;

    // Initialize the pattern history table (PHT)
    reg [1:0] pht [0:127];

    // Initialize the output signals
    assign predict_taken = (pht[{predict_pc[6:1], global_history[6:1]}] > 1'b1);
    assign predict_history = global_history;

    always @(*) begin
        // Update the global branch history register based on the predicted branch direction
        if (predict_valid) begin
            next_global_history = {global_history[5:0], predict_taken};
        end else begin
            next_global_history = global_history;
        end
    end

    always @(posedge clk) begin
        // Reset the global branch history register and the PHT on asynchronous reset
        if (areset) begin
            global_history <= 7'b0;
            for (int i = 0; i < 128; i++) begin
                pht[i] <= 2'b0;
            end
        end else begin
            // Update the global branch history register
            global_history <= next_global_history;

            // Update the PHT based on the training request
            if (train_valid) begin
                reg [6:0] index;
                index = {train_pc[6:1], train_history[6:1]};
                if (train_taken) begin
                    if (pht[index] < 2'b11) begin
                        pht[index] <= pht[index] + 1'b1;
                    end
                end else begin
                    if (pht[index] > 2'b00) begin
                        pht[index] <= pht[index] - 1'b1;
                    end
                end

                // Recover the global branch history register if the branch was a misprediction
                if (train_mispredicted) begin
                    global_history <= train_history;
                end
            end
        end
    end

endmodule