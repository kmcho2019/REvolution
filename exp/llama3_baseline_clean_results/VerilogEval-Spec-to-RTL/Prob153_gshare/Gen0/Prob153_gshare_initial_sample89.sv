module TopModule (
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

    // PHT (Pattern History Table) with 128 entries of 2-bit saturating counters
    reg [1:0] pht [127:0];
    
    // Global branch history register
    reg [6:0] history;

    // Generate index for PHT using xor hash of pc and global branch history
    wire [6:0] index;
    assign index = predict_pc ^ history;

    // Initialize PHT and global branch history register on asynchronous reset
    always @(posedge areset or posedge clk) begin
        if (areset) begin
            for (int i = 0; i < 128; i++) begin
                pht[i] <= 2'b01; // Initialize all counters to weakly taken
            end
            history <= 7'b0;
        end
    end

    // Update global branch history register on prediction
    always @(posedge clk) begin
        if (predict_valid) begin
            history <= {history[5:0], predict_taken};
        end
        if (train_valid && train_mispredicted) begin
            history <= train_history;
        end
    end

    // Update PHT on training
    always @(posedge clk) begin
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

    // Generate prediction output
    always @(posedge clk) begin
        if (predict_valid) begin
            if (pht[predict_pc ^ history] >= 2'b10) begin
                predict_taken <= 1'b1;
            end else begin
                predict_taken <= 1'b0;
            end
            predict_history <= history;
        end
    end

endmodule