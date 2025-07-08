module TopModule(
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    // Pattern History Table: 128 entries of 2-bit saturating counters
    // 2-bit saturating counter states (MSB=prediction bit):
    // 00 Strongly Not Taken
    // 01 Weakly Not Taken
    // 10 Weakly Taken
    // 11 Strongly Taken
    reg [1:0] PHT [0:127];

    // Global branch history register (7 bits)
    reg [6:0] global_history;

    // Compute indices for predict and train accesses
    wire [6:0] predict_index = predict_pc ^ global_history;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read PHT entries combinationally
    wire [1:0] predict_pht_entry = PHT[predict_index];
    wire [1:0] train_pht_entry = PHT[train_index];

    // Prediction output
    assign predict_taken = (predict_valid) ? predict_pht_entry[1] : 1'b0;
    assign predict_history = global_history;

    // Functions to saturate counter update
    function [1:0] saturate_increment(input [1:0] val);
        begin
            case(val)
                2'b00: saturate_increment = 2'b01;
                2'b01: saturate_increment = 2'b10;
                2'b10: saturate_increment = 2'b11;
                2'b11: saturate_increment = 2'b11;
                default: saturate_increment = 2'b01;
            endcase
        end
    endfunction

    function [1:0] saturate_decrement(input [1:0] val);
        begin
            case(val)
                2'b00: saturate_decrement = 2'b00;
                2'b01: saturate_decrement = 2'b00;
                2'b10: saturate_decrement = 2'b01;
                2'b11: saturate_decrement = 2'b10;
                default: saturate_decrement = 2'b01;
            endcase
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Async reset: clear global_history and init PHT to weakly taken (2'b01)
            global_history <= 7'b0;
            for (i=0; i<128; i=i+1) begin
                PHT[i] <= 2'b01; // weakly taken as initial state
            end
        end else begin
            // Training has priority for global_history update if train_valid & train_mispredicted
            if (train_valid) begin
                // Update PHT entry at train_index
                if (train_taken) begin
                    PHT[train_index] <= saturate_increment(PHT[train_index]);
                end else begin
                    PHT[train_index] <= saturate_decrement(PHT[train_index]);
                end

                if (train_mispredicted) begin
                    // Recover global_history to train_history on misprediction
                    global_history <= train_history;
                end else if (predict_valid && !(train_mispredicted)) begin
                    // If no misprediction, but both train and predict valid in same cycle,
                    // prediction updates global history by predicted outcome (train takes no precedence here)
                    // Actually per spec, training takes precedence only if mispredicted.
                    // So if train_valid & predict_valid and not mispredicted, global history updated with predicted taken.
                    // Prediction outcome is from PHT before update this cycle.
                    global_history <= {global_history[5:0], predict_taken};
                end else if (predict_valid) begin
                    // Only prediction valid, update global_history with predicted outcome
                    global_history <= {global_history[5:0], predict_taken};
                end
                // Else no valid inputs: no global_history change

            end else begin
                // No training valid
                if (predict_valid) begin
                    // Update global_history with predicted outcome
                    global_history <= {global_history[5:0], predict_taken};
                end
                // else no change
            end
        end
    end

endmodule