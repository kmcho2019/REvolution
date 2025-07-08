module TopModule(
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

    // Pattern History Table: 128 entries, 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global history register
    reg [6:0] global_history;

    // Calculate index: XOR of pc and global_history for prediction
    wire [6:0] predict_index = predict_pc ^ global_history;
    wire [1:0] pht_entry = pht[predict_index];

    // Prediction is taken if top bit of counter is 1 (2 or 3)
    wire predict_taken_wire = pht_entry[1];

    assign predict_taken = predict_taken_wire;
    assign predict_history = global_history;

    // Calculate index for training
    wire [6:0] train_index = train_pc ^ train_history;
    reg [1:0] train_pht_entry;

    // For training PHT entry read, latch at posedge clk
    // Because pht is synchronous RAM, need to read pht[train_index] combinationally
    // This is possible because pht is regs here, so combinational read

    // Saturating increment/decrement function
    function [1:0] saturating_update;
        input [1:0] curr;
        input       taken; // 1 = increment, 0 = decrement
        begin
            if (taken) begin
                case (curr)
                    2'b00: saturating_update = 2'b01;
                    2'b01: saturating_update = 2'b10;
                    2'b10: saturating_update = 2'b11;
                    2'b11: saturating_update = 2'b11;
                    default: saturating_update = 2'b10;
                endcase
            end else begin
                case (curr)
                    2'b00: saturating_update = 2'b00;
                    2'b01: saturating_update = 2'b00;
                    2'b10: saturating_update = 2'b01;
                    2'b11: saturating_update = 2'b10;
                    default: saturating_update = 2'b01;
                endcase
            end
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize global history and PHT on reset
            global_history <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b10; // weakly taken
            end
        end else begin
            // Update PHT on training
            if (train_valid) begin
                // Read current PHT entry for train_index
                train_pht_entry = pht[train_index];
                // Update saturating counter based on train_taken
                pht[train_index] <= saturating_update(train_pht_entry, train_taken);
            end

            // Update global_history with priority: training misprediction > prediction
            if (train_valid && train_mispredicted) begin
                // On misprediction, recover global_history to train_history
                global_history <= train_history;
            end else if (predict_valid) begin
                // Otherwise, update global_history with predicted direction
                // global_history shifts left by 1, LSB = predicted taken
                // (i.e., global_history[6:1] = global_history[5:0], global_history[0] = predict_taken)
                global_history <= {global_history[5:0], predict_taken_wire};
            end
            // else no update to global_history
        end
    end

endmodule