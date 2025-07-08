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

    // Pattern History Table: 128 entries of 2-bit saturating counters
    // 2'b00: strongly not taken, 2'b01: weakly not taken
    // 2'b10: weakly taken, 2'b11: strongly taken
    reg [1:0] PHT [0:127];

    // Global history register
    reg [6:0] global_history;

    // Compute index for prediction and training by XORing PC and history
    wire [6:0] predict_index = predict_pc ^ global_history;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read PHT entries for prediction and training
    wire [1:0] predict_counter = PHT[predict_index];
    wire [1:0] train_counter = PHT[train_index];

    // Prediction output: taken if MSB of counter is 1
    assign predict_taken = (predict_valid) ? predict_counter[1] : 1'b0;

    // Output the global history used for prediction (current global_history)
    assign predict_history = global_history;

    // Next state registers for PHT and global_history updated on clock edge
    integer i;

    // Saturating counter update function for taken/not taken outcome
    function [1:0] saturating_counter_update;
        input [1:0] counter;
        input taken;
        begin
            if (taken) begin
                if (counter != 2'b11)
                    saturating_counter_update = counter + 1;
                else
                    saturating_counter_update = counter;
            end else begin
                if (counter != 2'b00)
                    saturating_counter_update = counter - 1;
                else
                    saturating_counter_update = counter;
            end
        end
    endfunction

    // On clock edge or asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset global_history and PHT entries
            global_history <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                // Initialize counters to weakly taken (2) as a reasonable default
                PHT[i] <= 2'b10;
            end
        end else begin
            // Update PHT on training valid
            if (train_valid) begin
                PHT[train_index] <= saturating_counter_update(train_counter, train_taken);
            end

            // Update global_history register
            if (train_valid && train_mispredicted) begin
                // Recover history to the train_history (state after mispredicted branch completes)
                global_history <= train_history;
            end else if (predict_valid) begin
                // Update global_history with predicted direction if no misprediction training
                // Prediction takes the MSB of the counter to update history
                global_history <= {global_history[5:0], predict_counter[1]};
            end
            // Else no change to global_history
        end
    end

endmodule