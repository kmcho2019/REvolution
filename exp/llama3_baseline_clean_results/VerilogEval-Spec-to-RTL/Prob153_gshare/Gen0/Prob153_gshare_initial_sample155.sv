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

    reg [6:0] global_branch_history;
    reg [6:0] recovered_global_branch_history;
    reg [1:0] pht [127:0];

    integer i;

    initial begin
        for (i = 0; i < 128; i++) begin
            pht[i] = 2'b01; // Initialize PHT counters to weakly taken
        end
        global_branch_history = 7'b0;
        recovered_global_branch_history = 7'b0;
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            for (i = 0; i < 128; i++) begin
                pht[i] = 2'b01; // Reset PHT counters to weakly taken
            end
            global_branch_history <= 7'b0;
            recovered_global_branch_history <= 7'b0;
        end else begin
            if (train_valid) begin
                // Update PHT counter
                integer index;
                index = (train_pc ^ train_history) % 128;
                if (train_taken &&!train_mispredicted) begin
                    // Taken and correct prediction
                    if (pht[index] < 2'b11) begin
                        pht[index] <= pht[index] + 1;
                    end
                end else if (!train_taken &&!train_mispredicted) begin
                    // Not taken and correct prediction
                    if (pht[index] > 2'b00) begin
                        pht[index] <= pht[index] - 1;
                    end
                end else if (train_mispredicted) begin
                    // Misprediction, recover global branch history
                    global_branch_history <= recovered_global_branch_history;
                    // Update PHT counter
                    if (train_taken) begin
                        // Taken and misprediction
                        if (pht[index] < 2'b11) begin
                            pht[index] <= pht[index] + 1;
                        end
                    end else begin
                        // Not taken and misprediction
                        if (pht[index] > 2'b00) begin
                            pht[index] <= pht[index] - 1;
                        end
                    end
                end
            end

            if (predict_valid) begin
                // Update global branch history
                global_branch_history <= {global_branch_history[5:0], predict_taken};
            end

            if (train_valid && train_mispredicted) begin
                // Store recovered global branch history
                recovered_global_branch_history <= global_branch_history;
            end
        end
    end

    always @(*) begin
        integer index;
        index = (predict_pc ^ global_branch_history) % 128;
        if (pht[index] >= 2'b10) begin
            predict_taken = 1'b1; // Taken
        end else begin
            predict_taken = 1'b0; // Not taken
        end
        predict_history = global_branch_history;
    end

endmodule