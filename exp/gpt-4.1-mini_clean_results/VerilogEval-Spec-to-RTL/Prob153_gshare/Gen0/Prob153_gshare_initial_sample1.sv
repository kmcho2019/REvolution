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

    // Parameters
    localparam PHT_SIZE = 128; // 2^7 entries
    localparam COUNTER_WIDTH = 2;

    // Pattern History Table (PHT) - 2-bit saturating counters
    // 00 - strongly not taken
    // 01 - weakly not taken
    // 10 - weakly taken
    // 11 - strongly taken
    reg [1:0] pht [0:PHT_SIZE-1];

    // Global branch history register (7 bits)
    reg [6:0] global_history;

    // Wires for prediction index
    wire [6:0] predict_index = predict_pc ^ global_history;
    wire [1:0] pht_predict_entry = pht[predict_index];

    // Wires for training index
    wire [6:0] train_index = train_pc ^ train_history;
    reg  [1:0] pht_train_entry; // read value at train_index before update (read at clock edge)

    // Combinational prediction output based on PHT entry MSB
    wire predict_taken_next = (pht_predict_entry[1] == 1'b1);

    // Next global history value on prediction update (shift left and append predicted bit)
    wire [6:0] global_history_pred_next = {global_history[5:0], predict_taken_next};

    // Next global history value on training recovery (use train_history)
    wire [6:0] global_history_train_next = train_history;

    // For update of PHT entry on training
    function [1:0] saturating_counter_update;
        input [1:0] current;
        input       taken; // 1 = branch taken, 0 = not taken
        begin
            case (current)
                2'b00: saturating_counter_update = taken ? 2'b01 : 2'b00; // 00->01 if taken else stay
                2'b01: saturating_counter_update = taken ? 2'b10 : 2'b00; // 01->10 if taken else 00
                2'b10: saturating_counter_update = taken ? 2'b11 : 2'b01; // 10->11 if taken else 01
                2'b11: saturating_counter_update = taken ? 2'b11 : 2'b10; // 11->11 if taken else 10
                default: saturating_counter_update = 2'b01;
            endcase
        end
    endfunction

    integer i;

    // Asynchronous reset and initial block for PHT initialization
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize global history to zero on reset
            global_history <= 7'b0;
            // Initialize PHT entries to weakly not taken (01)
            for (i = 0; i < PHT_SIZE; i = i + 1) begin
                pht[i] <= 2'b01;
            end
        end else begin
            // Read PHT entry for training index at clock edge
            pht_train_entry <= pht[train_index];

            // Update PHT entry on training if train_valid
            if (train_valid) begin
                pht[train_index] <= saturating_counter_update(pht_train_entry, train_taken);
            end

            // Update global history register
            // Condition for updating global_history:
            // If train_valid & train_mispredicted: update with train_history (recovery)
            // Else if predict_valid and NOT (train_valid & train_mispredicted): update with prediction
            if (train_valid && train_mispredicted) begin
                global_history <= global_history_train_next;
            end else if (predict_valid) begin
                global_history <= global_history_pred_next;
            end
            // else keep global_history unchanged
        end
    end

    // Predict output combinational logic
    always @(*) begin
        if (predict_valid) begin
            predict_taken  = predict_taken_next;
            predict_history = global_history;
        end else begin
            // When not valid, outputs can hold previous or zero
            // Here hold previous
            predict_taken  = 1'b0;
            predict_history = 7'b0;
        end
    end

endmodule