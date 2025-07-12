module TopModule(
    input         clk,
    input         areset,

    // Prediction interface
    input         predict_valid,
    input  [6:0]  predict_pc,
    output        predict_taken,
    output [6:0]  predict_history,

    // Training interface
    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

    // Pattern History Table (PHT): 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global history register (7 bits), speculative and updated on prediction,
    // recovered on misprediction training
    reg [6:0] ghr;

    // Registers to hold output predict_history and prediction taken bit
    reg predict_taken_reg;
    reg [6:0] predict_history_reg;

    // Compute indices by XOR of pc and global history
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read current PHT entries asynchronously
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire [1:0] pht_train_entry = pht[train_index];

    // Predict taken if MSB of saturating counter is 1
    wire predict_taken_wire = pht_predict_entry[1] && predict_valid;

    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] curr;
        input       taken;
        begin
            if (taken) begin
                saturate_update = (curr == 2'b11) ? 2'b11 : curr + 2'b01;
            end else begin
                saturate_update = (curr == 2'b00) ? 2'b00 : curr - 2'b01;
            end
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to Weakly Not Taken (01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;

            ghr <= 7'b0;

            predict_taken_reg <= 1'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // Default: no update to ghr or pht unless train_valid or predict_valid asserted

            // Update PHT entry on training
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht_train_entry, train_taken);

                if (train_mispredicted) begin
                    // On mispredict training, recover ghr to train_history (undo speculation)
                    ghr <= train_history;
                end else begin
                    // On correct training, ghr is not modified here (speculative updates happen only on prediction)
                    // So no update to ghr
                end
            end else if (predict_valid) begin
                // On prediction (without training), update ghr speculatively with predicted taken bit
                // Append predicted taken bit (MSB of PHT entry) into history
                ghr <= {ghr[5:0], pht_predict_entry[1]};
            end

            // Update output registers
            if (predict_valid) begin
                predict_taken_reg <= predict_taken_wire;
                predict_history_reg <= ghr; // current ghr before update
            end else begin
                // If no prediction this cycle, outputs remain as last valid values
                // Alternatively, could clear outputs to zero if desired
                predict_taken_reg <= 1'b0;
                predict_history_reg <= 7'b0;
            end
        end
    end

endmodule