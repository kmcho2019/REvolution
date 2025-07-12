module TopModule (
    input          clk,
    input          areset,

    input          predict_valid,
    input  [6:0]   predict_pc,
    output         predict_taken,
    output [6:0]   predict_history,

    input          train_valid,
    input          train_taken,
    input          train_mispredicted,
    input  [6:0]   train_history,
    input  [6:0]   train_pc
);

    // Pattern History Table: 128 entries of 2-bit saturating counters
    // Encoding: 2'b00 Strongly Not Taken, 2'b01 Weakly Not Taken,
    //           2'b10 Weakly Taken,     2'b11 Strongly Taken
    reg [1:0] PHT [0:127];

    // Global history register (7 bits)
    reg [6:0] global_history;

    // Wire indices for predict and train
    wire [6:0] predict_index = predict_pc ^ global_history;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Read PHT entries combinationally for prediction output
    wire [1:0] predict_pht_entry = PHT[predict_index];

    // Prediction: taken if MSB of saturating counter is 1
    assign predict_taken = (predict_valid) ? predict_pht_entry[1] : 1'b0;
    // Output the global history used for prediction
    assign predict_history = (predict_valid) ? global_history : 7'b0;

    integer i;

    // Saturating counter update function
    function [1:0] saturating_counter_update;
        input [1:0] current;
        input       taken;
        begin
            if(taken) begin
                if(current == 2'b11)
                    saturating_counter_update = 2'b11;
                else
                    saturating_counter_update = current + 1'b1;
            end else begin
                if(current == 2'b00)
                    saturating_counter_update = 2'b00;
                else
                    saturating_counter_update = current - 1'b1;
            end
        end
    endfunction

    // Internal registers to hold next state updates for PHT and history
    reg [1:0] PHT_next [0:127];
    reg [6:0] global_history_next;
    reg       history_update_valid;

    always @(*) begin
        // Default next states are current states
        for(i=0; i<128; i=i+1) begin
            PHT_next[i] = PHT[i];
        end
        global_history_next = global_history;
        history_update_valid = 1'b0;

        // Training PHT update when valid
        if(train_valid) begin
            // Update the PHT at train_index with train_taken outcome
            PHT_next[train_index] = saturating_counter_update(PHT[train_index], train_taken);
        end

        // Global history update decision
        // Training misprediction has priority to restore history to train_history
        if(train_valid && train_mispredicted) begin
            global_history_next = train_history;
            history_update_valid = 1'b1;
        end
        else if(predict_valid) begin
            // Update history by shifting in predicted taken bit (if no training misprediction)
            // New history = (global_history << 1) + predicted taken bit
            global_history_next = {global_history[5:0], predict_pht_entry[1]};
            history_update_valid = 1'b1;
        end
    end

    // Sequential logic: registers update on posedge clk or async reset
    always @(posedge clk or posedge areset) begin
        if(areset) begin
            global_history <= 7'b0;
            for(i=0; i<128; i=i+1) begin
                // Initialize PHT to weakly taken (2'b10)
                PHT[i] <= 2'b10;
            end
        end else begin
            // Update PHT entries
            for(i=0; i<128; i=i+1) begin
                PHT[i] <= PHT_next[i];
            end

            // Update global history only if valid update
            if(history_update_valid) begin
                global_history <= global_history_next;
            end
        end
    end

endmodule