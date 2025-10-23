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

    // Pattern History Table (PHT)
    reg [1:0] pht [127:0];

    // Global Branch History Register
    reg [6:0] global_history;

    // Initialize PHT and global history
    initial begin
        for (int i = 0; i < 128; i++) begin
            pht[i] = 2'b01; // Initialize to weakly taken
        end
        global_history = 7'b0;
    end

    // Asynchronous reset
    always @(posedge areset) begin
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01; // Reset PHT to weakly taken
        end
        global_history <= 7'b0; // Reset global history
    end

    // Synchronous logic
    always @(posedge clk) begin
        if (train_valid) begin
            // Calculate index for PHT
            reg [6:0] index;
            index = {train_history[6:1] ^ train_pc[6:1]};

            // Update PHT based on actual branch outcome and misprediction status
            if (train_mispredicted) begin
                if (train_taken) begin
                    // Mispredicted taken branch
                    if (pht[index] != 2'b11) begin
                        pht[index] <= pht[index] + 1;
                    end
                end else begin
                    // Mispredicted not taken branch
                    if (pht[index] != 2'b00) begin
                        pht[index] <= pht[index] - 1;
                    end
                end
            end else begin
                if (train_taken) begin
                    // Correctly predicted taken branch
                    if (pht[index] != 2'b11) begin
                        pht[index] <= pht[index] + 1;
                    end
                end else begin
                    // Correctly predicted not taken branch
                    if (pht[index] != 2'b00) begin
                        pht[index] <= pht[index] - 1;
                    end
                end
            end

            // Recover global history register if misprediction occurred
            if (train_mispredicted) begin
                global_history <= train_history;
            end
        end

        // Update global history register for predicted branch
        if (predict_valid) begin
            global_history <= {global_history[5:0], predict_taken};
        end
    end

    // Generate prediction based on current global history and PC
    always @(*) begin
        reg [6:0] index;
        index = {global_history[6:1] ^ predict_pc[6:1]};

        // Use PHT to generate prediction
        if (pht[index] >= 2'b10) begin
            predict_taken = 1'b1; // Predict taken
        end else begin
            predict_taken = 1'b0; // Predict not taken
        end

        predict_history = global_history;
    end

endmodule