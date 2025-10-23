module TopModule(
    input            clk,
    input            areset,

    input            predict_valid,
    input      [6:0]  predict_pc,
    output           predict_taken,
    output     [6:0]  predict_history,

    input            train_valid,
    input            train_taken,
    input            train_mispredicted,
    input      [6:0]  train_history,
    input      [6:0]  train_pc
);

reg [6:0] pht [0:127]; // 128-entry table of two-bit saturating counters
reg [6:0] global_history; // 7-bit global branch history register

// Hash function to map pc and global history into a 7-bit index
function [6:0] hash;
    input [6:0] pc;
    input [6:0] history;
    begin
        hash = pc ^ history;
    end
endfunction

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Initialize PHT and global history register on reset
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01; // Initialize counters to weakly taken
        end
        global_history <= 7'b0;
    end else begin
        // Update global history register for predicted branch
        if (predict_valid) begin
            global_history <= {global_history[5:0], predict_taken};
        end

        // Train PHT entry based on actual branch outcome
        if (train_valid) begin
            reg [6:0] index;
            index = hash(train_pc, train_history);
            if (train_taken) begin
                // Increment counter if branch was taken
                if (pht[index] < 2'b11) begin
                    pht[index] <= pht[index] + 1;
                end
            end else begin
                // Decrement counter if branch was not taken
                if (pht[index] > 2'b00) begin
                    pht[index] <= pht[index] - 1;
                end
            end

            // Recover global history register if mispredicted
            if (train_mispredicted) begin
                global_history <= train_history;
            end
        end
    end
end

always @(*) begin
    reg [6:0] index;
    index = hash(predict_pc, global_history);
    if (pht[index] >= 2'b10) begin
        predict_taken = 1'b1; // Predict taken if counter is strongly taken
    end else begin
        predict_taken = 1'b0; // Predict not taken if counter is weakly taken or not taken
    end
    predict_history = global_history;
end

endmodule