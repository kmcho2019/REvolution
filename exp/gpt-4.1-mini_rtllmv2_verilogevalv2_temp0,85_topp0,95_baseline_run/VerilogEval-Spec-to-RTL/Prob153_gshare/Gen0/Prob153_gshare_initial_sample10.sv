module TopModule(
    input        clk,
    input        areset,
    // Prediction interface
    input        predict_valid,
    input  [6:0] predict_pc,
    output       predict_taken,
    output [6:0] predict_history,
    // Training interface
    input        train_valid,
    input        train_taken,
    input        train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);

    // PHT: 128 entries of 2-bit saturating counters
    reg [1:0] PHT [0:127];

    // Global history register (GHR)
    reg [6:0] GHR;

    // Next GHR register to hold updated GHR after prediction
    reg [6:0] next_GHR;

    // Index calculation for prediction and training
    wire [6:0] predict_index;
    wire [6:0] train_index;

    assign predict_index = predict_pc ^ GHR;
    assign train_index = train_pc ^ train_history;

    // Current prediction counter value (read from PHT)
    wire [1:0] predict_counter;
    assign predict_counter = PHT[predict_index];

    // Prediction output: taken if upper bit of counter is 1
    assign predict_taken = predict_valid ? predict_counter[1] : 1'b0;

    // Output the GHR used for prediction (the current GHR)
    assign predict_history = predict_valid ? GHR : 7'b0;

    // Saturating counter update function
    function [1:0] saturating_counter_update;
        input [1:0] counter;
        input       taken;
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

    integer i;

    // On asynchronous reset, clear GHR and initialize PHT to weakly taken (2'b10)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0;
            next_GHR <= 7'b0;
            for (i=0; i<128; i=i+1) begin
                PHT[i] <= 2'b10; // Weakly taken
            end
        end else begin
            // PHT update on train_valid
            if (train_valid) begin
                PHT[train_index] <= saturating_counter_update(PHT[train_index], train_taken);
            end

            // Update GHR according to priority rules:
            // If mispredicted training, restore GHR to train_history
            // Else if predict_valid, update GHR with predicted direction
            // Else keep GHR unchanged
            if (train_valid && train_mispredicted) begin
                GHR <= train_history;
                next_GHR <= train_history;
            end else if (predict_valid) begin
                // Update next_GHR with predicted bit
                // Shift in predicted direction (predict_taken)
                // next_GHR updated combinationally below
                GHR <= next_GHR;
            end else begin
                GHR <= GHR; // Hold current GHR
                next_GHR <= next_GHR; // Hold next_GHR
            end
        end
    end

    // Combinational logic for next_GHR update on prediction
    // This is updated every cycle (not on reset)
    always @(*) begin
        if (predict_valid) begin
            // Shift left by 1 and insert predicted bit at LSB
            next_GHR = {GHR[5:0], predict_counter[1]};
        end else begin
            next_GHR = GHR; // hold
        end
    end

endmodule