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

    // Pattern History Table: 128 entries, 2-bit saturating counters
    reg [1:0] PHT [0:127];
    reg [6:0] GHR;

    // Prediction output registers: latched on predict_valid
    reg        predict_taken_reg;
    reg [6:0]  predict_history_reg;

    // Combinational prediction signals
    wire [6:0] predict_index = predict_pc ^ GHR;
    wire [1:0] predict_counter = PHT[predict_index];
    wire       predict_taken_next = predict_counter[1]; // MSB is taken bit

    // Training index calculation
    wire [6:0] train_index = train_pc ^ train_history;

    // Saturating counter update function
    function [1:0] saturate_update(input [1:0] counter, input taken);
        begin
            case (counter)
                2'b00: saturate_update = taken ? 2'b01 : 2'b00;
                2'b01: saturate_update = taken ? 2'b10 : 2'b00;
                2'b10: saturate_update = taken ? 2'b11 : 2'b01;
                2'b11: saturate_update = taken ? 2'b11 : 2'b10;
                default: saturate_update = 2'b01; // weakly not taken
            endcase
        end
    endfunction

    integer i;

    // Outputs driven by latched registers
    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize GHR and PHT to weakly not taken
            GHR <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
            predict_taken_reg <= 1'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // Latch prediction outputs on predict_valid
            if (predict_valid) begin
                predict_taken_reg <= predict_taken_next; // prediction from current PHT state
                predict_history_reg <= GHR;               // history before update
            end

            // Update PHT on training
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Update GHR:
            // Priority 1: On mispredicted training, restore GHR to train_history
            // Priority 2: Else if prediction valid, shift in combinational predicted bit (predict_taken_next)
            if (train_valid && train_mispredicted) begin
                GHR <= train_history;
            end else if (predict_valid) begin
                GHR <= {GHR[5:0], predict_taken_next};
            end
            // else retain current GHR
        end
    end

endmodule