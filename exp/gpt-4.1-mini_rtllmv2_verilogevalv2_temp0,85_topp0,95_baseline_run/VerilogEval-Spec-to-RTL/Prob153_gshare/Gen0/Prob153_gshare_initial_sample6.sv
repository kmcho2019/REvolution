module TopModule (
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output reg predict_taken,
    output reg [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    // Pattern History Table: 128 entries of 2-bit saturating counters
    // 2'b00 = strongly not taken
    // 2'b01 = weakly not taken
    // 2'b10 = weakly taken
    // 2'b11 = strongly taken
    reg [1:0] PHT [0:127];

    // Global History Register (7 bits)
    reg [6:0] GHR;

    // Index calculation functions
    wire [6:0] predict_index = predict_pc ^ GHR;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read current PHT entry for prediction
    wire [1:0] predict_pht_entry = PHT[predict_index];

    // Prediction logic (combinational)
    wire predict_dir = predict_pht_entry[1]; // MSB is the prediction bit (taken if 1)

    // Update PHT entry function (saturating counter)
    function [1:0] saturating_update;
        input [1:0] curr;
        input taken;
        begin
            case(curr)
                2'b00: saturating_update = taken ? 2'b01 : 2'b00;
                2'b01: saturating_update = taken ? 2'b10 : 2'b00;
                2'b10: saturating_update = taken ? 2'b11 : 2'b01;
                2'b11: saturating_update = taken ? 2'b11 : 2'b10;
                default: saturating_update = 2'b01;
            endcase
        end
    endfunction

    integer i;

    // Asynchronous reset and initialization
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0;
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
        end else begin
            // Update PHT on training if valid
            if (train_valid) begin
                PHT[train_index] <= saturating_update(PHT[train_index], train_taken);
            end

            // Update GHR:
            // If training valid and mispredicted, restore GHR to train_history
            // Else if prediction valid and no misprediction training this cycle, update GHR with predicted direction
            if (train_valid && train_mispredicted) begin
                GHR <= train_history;
            end else if (predict_valid && !(train_valid && train_mispredicted)) begin
                // Shift in predicted direction
                GHR <= {GHR[5:0], predict_dir};
            end
            // Else no change to GHR
        end
    end

    // Prediction outputs combinational logic
    always @(*) begin
        if (predict_valid) begin
            predict_taken = predict_dir;
            predict_history = GHR;
        end else begin
            predict_taken = 1'b0;
            predict_history = 7'b0;
        end
    end

endmodule