module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire        predict_valid,
    input  wire [6:0]  predict_pc,
    output reg         predict_taken,
    output reg [6:0]   predict_history,
    input  wire        train_valid,
    input  wire        train_taken,
    input  wire        train_mispredicted,
    input  wire [6:0]  train_history,
    input  wire [6:0]  train_pc
);

    localparam PHT_SIZE = 128;

    // 2-bit saturating counter states:
    // 00 strong not taken
    // 01 weak not taken
    // 10 weak taken
    // 11 strong taken

    reg [1:0] pht [0:PHT_SIZE-1];
    reg [6:0] global_history;

    // Registers for synchronous PHT training read
    reg [6:0] train_index_reg;
    reg [1:0] pht_train_entry_reg;

    // Combinational indexes for prediction and training
    wire [6:0] predict_index = predict_pc ^ global_history;
    wire [6:0] train_index = train_pc ^ train_history;

    // Prediction: read PHT entry asynchronously for prediction output,
    // since PHT is reg array, asynchronous read is allowed for combinational output
    wire [1:0] pht_predict_entry = pht[predict_index];

    wire predict_taken_next = pht_predict_entry[1];

    // Next global history for prediction update
    wire [6:0] global_history_pred_next = {global_history[5:0], predict_taken_next};

    // Next global history for training recovery (train_history)
    wire [6:0] global_history_train_next = train_history;

    // Saturating counter update function
    function [1:0] saturating_counter_update;
        input [1:0] current;
        input       taken;
        begin
            case (current)
                2'b00: saturating_counter_update = taken ? 2'b01 : 2'b00;
                2'b01: saturating_counter_update = taken ? 2'b10 : 2'b00;
                2'b10: saturating_counter_update = taken ? 2'b11 : 2'b01;
                2'b11: saturating_counter_update = taken ? 2'b11 : 2'b10;
                default: saturating_counter_update = 2'b01;
            endcase
        end
    endfunction

    integer i;

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            for (i = 0; i < PHT_SIZE; i = i + 1) begin
                pht[i] <= 2'b01; // weakly not taken
            end
            train_index_reg <= 7'b0;
            pht_train_entry_reg <= 2'b01;
            // Initialize prediction outputs to 0
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            // Register train index and read PHT entry for training on next cycle
            train_index_reg <= train_index;
            pht_train_entry_reg <= pht[train_index];

            // Update PHT entry on training using registered index and entry (synchronous read)
            if (train_valid) begin
                pht[train_index_reg] <= saturating_counter_update(pht_train_entry_reg, train_taken);
            end

            // Update global_history following the priority:
            // If train_valid & train_mispredicted, recover global_history with train_history
            // Else if predict_valid, update global_history with predicted taken bit
            if (train_valid && train_mispredicted) begin
                global_history <= global_history_train_next;
            end else if (predict_valid) begin
                global_history <= global_history_pred_next;
            end
            // else keep global_history unchanged

            // Register prediction outputs for stable outputs
            if (predict_valid) begin
                predict_taken <= predict_taken_next;
                // predict_history is the global_history *before* update,
                // which is current global_history before assignment above
                predict_history <= global_history;
            end else begin
                // If no prediction, hold outputs or clear
                predict_taken <= 1'b0;
                predict_history <= 7'b0;
            end
        end
    end

endmodule