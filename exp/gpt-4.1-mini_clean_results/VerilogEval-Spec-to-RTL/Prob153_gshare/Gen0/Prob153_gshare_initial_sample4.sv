module TopModule(
    input  wire        clk,
    input  wire        areset,

    input  wire        predict_valid,
    input  wire [6:0]  predict_pc,
    output wire        predict_taken,
    output wire [6:0]  predict_history,

    input  wire        train_valid,
    input  wire        train_taken,
    input  wire        train_mispredicted,
    input  wire [6:0]  train_history,
    input  wire [6:0]  train_pc
);

    // 2-bit saturating counter states:
    // 2'b00 = Strongly Not Taken
    // 2'b01 = Weakly Not Taken
    // 2'b10 = Weakly Taken
    // 2'b11 = Strongly Taken

    reg [1:0] PHT [0:127];  // Pattern History Table with 128 entries
    reg [6:0] GHR;          // Global History Register

    // Compute indices by XOR of PC and history
    wire [6:0] predict_index = predict_pc ^ GHR;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Current PHT values at indices
    wire [1:0] predict_pht_state = PHT[predict_index];
    wire [1:0] train_pht_state   = PHT[train_index];

    // Prediction is MSB of the 2-bit counter at predict_index
    assign predict_taken = (predict_pht_state[1]);

    // Output predict_history is current GHR (used in prediction)
    assign predict_history = GHR;

    // Next GHR calculation for prediction
    wire [6:0] ghr_next_pred;
    assign ghr_next_pred = {GHR[5:0], predict_taken};

    // Next state for saturating counters update function
    function [1:0] sat_counter_next;
        input [1:0] curr_state;
        input       taken;
        begin
            case (curr_state)
                2'b00: sat_counter_next = taken ? 2'b01 : 2'b00;
                2'b01: sat_counter_next = taken ? 2'b10 : 2'b00;
                2'b10: sat_counter_next = taken ? 2'b11 : 2'b01;
                2'b11: sat_counter_next = taken ? 2'b11 : 2'b10;
                default: sat_counter_next = 2'b10; // default weak taken
            endcase
        end
    endfunction

    // Registers to hold next PHT state for write-back
    reg [1:0] PHT_next [0:127];
    integer i;

    // On reset, initialize PHT to weakly taken (2'b10), GHR to 0
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0;
            for (i=0; i<128; i=i+1) begin
                PHT[i] <= 2'b10;
            end
        end else begin
            // Update PHT at train_index if train_valid
            if (train_valid) begin
                PHT[train_index] <= sat_counter_next(PHT[train_index], train_taken);
            end
            // No PHT update for prediction (read only)

            // Update GHR: if train_mispredicted & train_valid, restore to train_history
            // else if predict_valid and not (train_valid & train_mispredicted), update GHR with predicted taken
            if (train_valid && train_mispredicted) begin
                GHR <= train_history;
            end else if (predict_valid) begin
                GHR <= ghr_next_pred;
            end
        end
    end

endmodule