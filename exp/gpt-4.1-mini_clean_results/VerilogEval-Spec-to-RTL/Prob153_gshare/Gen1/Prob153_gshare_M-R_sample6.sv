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

    // 2-bit saturating counters states encoding:
    // 2'b00 = Strongly not taken
    // 2'b01 = Weakly not taken
    // 2'b10 = Weakly taken
    // 2'b11 = Strongly taken

    reg [1:0] PHT [0:127];
    reg [6:0] GHR;

    // Compute indices
    wire [6:0] predict_index = predict_pc ^ GHR;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Synchronous read of PHT for prediction:
    reg [1:0] predict_counter;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_counter <= 2'b01; // default weak not taken on reset
        end else begin
            predict_counter <= PHT[predict_index];
        end
    end

    assign predict_taken = predict_counter[1]; // MSB is prediction bit
    assign predict_history = GHR;

    // Read current train counter synchronously before update
    reg [1:0] train_counter_current;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            train_counter_current <= 2'b01;
        end else if (train_valid) begin
            train_counter_current <= PHT[train_index];
        end
    end

    // Function to saturate counters on taken/not taken updates
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            case(counter)
                2'b00: saturate_update = taken ? 2'b01 : 2'b00;
                2'b01: saturate_update = taken ? 2'b10 : 2'b00;
                2'b10: saturate_update = taken ? 2'b11 : 2'b01;
                2'b11: saturate_update = taken ? 2'b11 : 2'b10;
                default: saturate_update = 2'b01;
            endcase
        end
    endfunction

    // Update logic at clock edge
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01; // weakly not taken on reset
            end
            predict_counter <= 2'b01;
            train_counter_current <= 2'b01;
        end else begin
            // Update PHT on training
            if (train_valid) begin
                PHT[train_index] <= saturate_update(train_counter_current, train_taken);
            end

            // Update GHR:
            // Training misprediction restores GHR
            // Else if predict_valid and no mispredicted training, shift in predicted taken
            // Else hold GHR

            if (train_valid && train_mispredicted) begin
                GHR <= train_history;
            end else if (predict_valid && !(train_valid && train_mispredicted)) begin
                GHR <= {GHR[5:0], predict_taken};
            end
            // Else GHR unchanged
        end
    end

endmodule