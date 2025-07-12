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

// PHT (Pattern History Table) declaration
reg [1:0] pht [127:0];

// Global branch history register declaration
reg [6:0] global_history;

// Hash function to generate index for PHT
function [6:0] hash_function;
    input [6:0] pc;
    input [6:0] history;
    begin
        hash_function = pc ^ history;
    end
endfunction

// Update PHT entry
always @(posedge clk) begin
    if (~areset) begin
        // Initialize PHT entries to 2'b01 (weakly taken)
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
        global_history <= 7'b0;
    end else if (train_valid) begin
        // Calculate index for PHT
        reg [6:0] index;
        index = hash_function(train_pc, train_history);
        
        // Update PHT entry
        if (train_taken) begin
            if (pht[index] != 2'b11) begin
                pht[index] <= pht[index] + 1;
            end
        end else begin
            if (pht[index] != 2'b00) begin
                pht[index] <= pht[index] - 1;
            end
        end
        
        // Recover global branch history if mispredicted
        if (train_mispredicted) begin
            global_history <= train_history;
        end
    end else if (predict_valid) begin
        // Update global branch history for predicted branch
        if (predict_taken) begin
            global_history <= {global_history[5:0], 1'b1};
        end else begin
            global_history <= {global_history[5:0], 1'b0};
        end
    end
end

// Predict branch direction
always @(*) begin
    reg [6:0] index;
    index = hash_function(predict_pc, global_history);
    
    // Predict branch direction based on PHT entry
    if (pht[index] >= 2'b10) begin
        predict_taken = 1'b1;
    end else begin
        predict_taken = 1'b0;
    end
    
    predict_history = global_history;
end

endmodule