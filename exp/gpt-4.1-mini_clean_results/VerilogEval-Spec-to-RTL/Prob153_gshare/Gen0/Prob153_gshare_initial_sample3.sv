module TopModule(
    input clk,
    input areset,

    // Prediction interface
    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    // Training interface
    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    // 2-bit saturating counters: 2'b00 - strongly not taken, 2'b01 - weakly not taken,
    // 2'b10 - weakly taken, 2'b11 - strongly taken
    reg [1:0] PHT [0:127];
    reg [6:0] ghr; // global branch history register

    // Internal wires and regs
    wire [6:0] predict_index;
    wire [6:0] train_index;

    // Calculate indices by XORing PC and history
    assign predict_history = ghr;
    assign predict_index = predict_pc ^ ghr;
    assign train_index = train_pc ^ train_history;

    wire [1:0] pht_read_counter;
    assign pht_read_counter = PHT[predict_index];

    // Prediction taken when MSB of counter is 1
    assign predict_taken = (pht_read_counter[1] == 1'b1) && predict_valid;

    // Helper function for saturating counter update
    function [1:0] update_counter;
        input [1:0] counter;
        input taken;
        begin
            case(counter)
                2'b00: update_counter = taken ? 2'b01 : 2'b00;
                2'b01: update_counter = taken ? 2'b10 : 2'b00;
                2'b10: update_counter = taken ? 2'b11 : 2'b01;
                2'b11: update_counter = taken ? 2'b11 : 2'b10;
                default: update_counter = 2'b01; // default weakly not taken
            endcase
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset: initialize PHT to weakly not taken (2'b01)
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
            ghr <= 7'b0;
        end else begin
            // Priority logic: if training with mispredicted, update history to train_history.
            // Else if prediction valid, update history by shifting in predicted taken.

            // Update PHT if training valid
            if (train_valid) begin
                PHT[train_index] <= update_counter(PHT[train_index], train_taken);
            end

            if (train_valid && train_mispredicted) begin
                // Recover history to train_history if mispredicted
                ghr <= train_history;
            end else if (predict_valid && !(train_valid && train_mispredicted)) begin
                // Update history with predicted taken bit: shift left by 1, insert predicted bit at LSB
                ghr <= {ghr[5:0], predict_taken};
            end
            // Else maintain ghr as is
        end
    end

endmodule