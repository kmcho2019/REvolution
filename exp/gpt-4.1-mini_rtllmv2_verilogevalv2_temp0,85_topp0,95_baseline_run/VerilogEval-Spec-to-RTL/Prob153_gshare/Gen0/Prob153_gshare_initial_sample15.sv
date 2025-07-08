module TopModule(
    input         clk,
    input         areset,

    input         predict_valid,
    input  [6:0]  predict_pc,
    output        predict_taken,
    output [6:0]  predict_history,

    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

    // PHT: 128 entries of 2-bit saturating counters
    // 2'b00 = strongly not taken
    // 2'b01 = weakly not taken
    // 2'b10 = weakly taken
    // 2'b11 = strongly taken

    reg [1:0] pht [0:127];
    integer i;

    // Global history register, 7 bits
    reg [6:0] global_history;

    // Combinational index for prediction and training
    wire [6:0] predict_index = predict_pc ^ global_history;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read PHT entries combinationally for predict and train
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire [1:0] pht_train_entry = pht[train_index];

    // Prediction output: taken if MSB of saturating counter = 1
    assign predict_taken = (pht_predict_entry[1] == 1'b1) && predict_valid;

    // Output the history used for prediction (the current global history at predict time)
    assign predict_history = global_history;

    // Internal next_history register to hold the next global history update from prediction
    reg [6:0] next_history;

    // Update PHT counter helper function (combinational)
    function [1:0] saturating_update;
        input [1:0] state;
        input       taken; // 1 if branch taken, 0 if not taken
        begin
            case(state)
                2'b00: saturating_update = taken ? 2'b01 : 2'b00;
                2'b01: saturating_update = taken ? 2'b10 : 2'b00;
                2'b10: saturating_update = taken ? 2'b11 : 2'b01;
                2'b11: saturating_update = taken ? 2'b11 : 2'b10;
                default: saturating_update = 2'b10; // default weakly taken
            endcase
        end
    endfunction

    // Speculative history update from prediction (to be committed on clk)
    wire [6:0] predicted_next_history = {global_history[5:0], predict_taken};

    // At clock posedge, update global_history and PHT entries according to rules
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset global history and PHT entries to weakly taken (2'b10)
            global_history <= 7'b0;
            for (i=0; i<128; i=i+1)
                pht[i] <= 2'b10;
            next_history <= 7'b0;
        end else begin
            // Update PHT entry on training if train_valid
            if (train_valid) begin
                // Update saturating counter at train_index with train_taken
                pht[train_index] <= saturating_update(pht_train_entry, train_taken);

                if (train_mispredicted) begin
                    // Recover global history to after mispredicted branch completes
                    // According to spec, recover to train_history + train_taken
                    global_history <= {train_history[5:0], train_taken};
                    // discard any prediction update in this cycle
                    next_history <= global_history; // just keep the restored history
                end else begin
                    // No misprediction: update global history with prediction if no conflict
                    // But if train and predict happen same cycle and train_mispredicted=0, both want to update
                    // The spec says training takes precedence only if mispredicted, so here we allow prediction update
                    global_history <= next_history; 
                end
            end else begin
                // No training, update global history with prediction update if predict_valid
                if (predict_valid) begin
                    global_history <= next_history;
                end
                // else keep global_history unchanged
            end

            // Update next_history for next cycle prediction update
            // Prediction update is only valid if predict_valid and no mispredicted training in same cycle
            // Because training takes precedence when mispredicted and predict_valid simultaneously,
            // so only update next_history if no mispredicted training this cycle.

            if (predict_valid && !(train_valid && train_mispredicted)) begin
                next_history <= predicted_next_history;
            end else begin
                // keep next_history same (either no predict or mispredicted training disables prediction update)
                next_history <= next_history;
            end
        end
    end

endmodule