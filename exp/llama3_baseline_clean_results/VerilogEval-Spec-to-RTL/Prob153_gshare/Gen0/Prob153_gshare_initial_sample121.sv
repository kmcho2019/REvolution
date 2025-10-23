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

    // Predicted branch direction
    reg predict_taken_reg;

    // Initialize PHT and global history register
    initial begin
        for (int i = 0; i < 128; i++) begin
            pht[i] = 2'b01; // Initialize to weakly taken
        end
        global_history = 7'b0;
    end

    // Asynchronous active-high reset
    always @(posedge areset) begin
        for (int i = 0; i < 128; i++) begin
            pht[i] = 2'b01; // Initialize to weakly taken
        end
        global_history = 7'b0;
    end

    // Update global history register and make prediction
    always @(posedge clk) begin
        if (predict_valid) begin
            // Hash pc and global history register to get index
            reg [6:0] index;
            index = predict_pc ^ global_history;

            // Make prediction based on PHT value
            if (pht[index[6:0]] >= 2'b10) begin
                predict_taken_reg = 1'b1; // Predict taken
            end else begin
                predict_taken_reg = 1'b0; // Predict not taken
            end

            // Update global history register for predicted branch
            if (predict_taken_reg) begin
                global_history = {global_history[5:0], 1'b1};
            end else begin
                global_history = {global_history[5:0], 1'b0};
            end
        end

        // Update PHT and global history register for training
        if (train_valid) begin
            // Hash pc and train history to get index
            reg [6:0] index;
            index = train_pc ^ train_history;

            // Update PHT based on actual branch outcome
            if (train_taken) begin
                if (pht[index[6:0]] < 2'b11) begin
                    pht[index[6:0]] = pht[index[6:0]] + 1'b1;
                end
            end else begin
                if (pht[index[6:0]] > 2'b00) begin
                    pht[index[6:0]] = pht[index[6:0]] - 1'b1;
                end
            end

            // Recover global history register if misprediction
            if (train_mispredicted) begin
                global_history = train_history;
            end
        end
    end

    // Output prediction and global history register
    assign predict_taken = predict_taken_reg;
    assign predict_history = global_history;

endmodule