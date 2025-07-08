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

// 2-bit saturating counter states:
// 2'b00 = strongly not taken
// 2'b01 = weakly not taken
// 2'b10 = weakly taken
// 2'b11 = strongly taken

// PHT table: 128 entries (7-bit index)
reg [1:0] PHT [0:127];

// Global history register
reg [6:0] global_history;

// Internal wire for predict index and train index
wire [6:0] predict_index = predict_pc ^ global_history;
wire [6:0] train_index = train_pc ^ train_history;

// Read PHT value for prediction combinationally
wire [1:0] pht_predict_entry = PHT[predict_index];

// Prediction is taken if MSB of counter is 1
wire predict_outcome = pht_predict_entry[1];

// Update PHT entry for training
// Use saturating counter update function
function [1:0] saturating_counter_next;
    input [1:0] state;
    input taken;
    begin
        case(state)
            2'b00: saturating_counter_next = taken ? 2'b01 : 2'b00;
            2'b01: saturating_counter_next = taken ? 2'b10 : 2'b00;
            2'b10: saturating_counter_next = taken ? 2'b11 : 2'b01;
            2'b11: saturating_counter_next = taken ? 2'b11 : 2'b10;
            default: saturating_counter_next = 2'b10; // default weakly taken
        endcase
    end
endfunction

integer i;

// Output combinational logic for predict outputs
always @(*) begin
    predict_taken = predict_outcome;
    predict_history = global_history;
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset global history and PHT entries
        global_history <= 7'b0;
        for (i = 0; i < 128; i = i + 1)
            PHT[i] <= 2'b10; // initialize to weakly taken
    end else begin
        // Priority: training has precedence over prediction on global history update
        if (train_valid) begin
            // Update PHT entry indexed by train_index with train_taken
            PHT[train_index] <= saturating_counter_next(PHT[train_index], train_taken);

            if (train_mispredicted) begin
                // Recover global history to train_history after mispredict
                global_history <= train_history;
            end else begin
                // If no mispredict, if no prediction update global history here? No.
                // Prediction update of global history happens only when no training or training is not mispredicted.
                // So do nothing here. Prediction update occurs below if train_valid=0.
            end
        end else if (predict_valid) begin
            // Update global history with prediction outcome
            // Shift left by 1, insert predicted taken bit at LSB
            global_history <= {global_history[5:0], predict_outcome};
        end
        // else no update to global history or PHT
    end
end

endmodule