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

    // Pattern History Table: 128 entries of 2-bit saturating counters
    reg [1:0] PHT [0:127];
    integer i;

    // Global History Register (GHR)
    reg [6:0] ghr;

    // Prediction combinational index and counter
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [1:0] predict_counter = PHT[predict_index];
    wire       predict_bit = predict_counter[1]; // MSB is prediction bit

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            if (taken) begin
                if (counter == 2'b11)
                    saturate_update = 2'b11;
                else
                    saturate_update = counter + 1;
            end else begin
                if (counter == 2'b00)
                    saturate_update = 2'b00;
                else
                    saturate_update = counter - 1;
            end
        end
    endfunction

    // Registered outputs for predict_taken and predict_history
    reg        predict_taken_r;
    reg  [6:0] predict_history_r;

    // Next state combinational signals for outputs
    wire        predict_taken_next;
    wire [6:0]  predict_history_next;

    // Determine next outputs combinationally
    assign predict_taken_next = predict_valid ? predict_bit : predict_taken_r;
    assign predict_history_next = predict_valid ? ghr : predict_history_r;

    // Output ports assigned to registered outputs
    assign predict_taken = predict_taken_r;
    assign predict_history = predict_history_r;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
            ghr <= 7'b0;
            predict_taken_r <= 1'b0;
            predict_history_r <= 7'b0;
        end else begin
            // Update registered prediction outputs
            predict_taken_r <= predict_taken_next;
            predict_history_r <= predict_history_next;

            // Update PHT on training valid
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Update GHR with priority: training mispredict > training > prediction > hold
            if (train_valid && train_mispredicted) begin
                ghr <= train_history; // recover GHR on mispredict
            end else if (train_valid) begin
                ghr <= {ghr[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_bit};
            end
            // else hold ghr unchanged
        end
    end

endmodule