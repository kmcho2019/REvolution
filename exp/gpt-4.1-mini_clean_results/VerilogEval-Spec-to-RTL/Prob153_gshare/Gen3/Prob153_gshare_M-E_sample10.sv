module TopModule (
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

    // PHT size and width
    localparam PHT_ENTRIES = 128;
    localparam PHT_IDX_BITS = 7;

    // 2-bit saturating counter states:
    // 00: Strongly not taken
    // 01: Weakly not taken
    // 10: Weakly taken
    // 11: Strongly taken

    // Separate arrays for stable prediction reads and for training writes
    reg [1:0] PHT_read  [0:PHT_ENTRIES-1];
    reg [1:0] PHT_write [0:PHT_ENTRIES-1];

    // Global History Register
    reg [6:0] GHR;

    // Compute indices for prediction and training
    wire [6:0] predict_index = predict_pc ^ GHR;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Prediction counter from stable read array
    wire [1:0] predict_counter = PHT_read[predict_index];

    assign predict_taken = predict_counter[1]; // MSB = prediction bit
    assign predict_history = GHR;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            case (counter)
                2'b00: saturate_update = taken ? 2'b01 : 2'b00;
                2'b01: saturate_update = taken ? 2'b10 : 2'b00;
                2'b10: saturate_update = taken ? 2'b11 : 2'b01;
                2'b11: saturate_update = taken ? 2'b11 : 2'b10;
                default: saturate_update = 2'b01; // default weakly not taken
            endcase
        end
    endfunction

    integer i;

    // Next GHR value calculation (combinational)
    reg [6:0] next_GHR;
    always @(*) begin
        if (train_valid && train_mispredicted) begin
            // Recover GHR on misprediction training
            next_GHR = train_history;
        end else if (predict_valid) begin
            // Shift in predicted taken bit
            next_GHR = {GHR[5:0], predict_taken};
        end else begin
            // Hold current GHR
            next_GHR = GHR;
        end
    end

    // Initialization and synchronous updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and initialize both PHT arrays to weakly not taken (01)
            GHR <= 7'b0;
            for (i = 0; i < PHT_ENTRIES; i = i + 1) begin
                PHT_read[i]  <= 2'b01;
                PHT_write[i] <= 2'b01;
            end
        end else begin
            // Update PHT_write entries on training
            if (train_valid) begin
                PHT_write[train_index] <= saturate_update(PHT_write[train_index], train_taken);
            end

            // Copy PHT_write contents to PHT_read to reflect latest training updates
            // This is done every cycle to ensure PHT_read is stable and up-to-date for predictions next cycle
            for (i = 0; i < PHT_ENTRIES; i = i + 1) begin
                PHT_read[i] <= PHT_write[i];
            end

            // Update GHR with priority to misprediction recovery
            GHR <= next_GHR;
        end
    end

endmodule