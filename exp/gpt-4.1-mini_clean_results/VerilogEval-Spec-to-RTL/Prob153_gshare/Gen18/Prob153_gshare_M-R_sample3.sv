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

    // Pattern History Table: 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global History Registers
    reg [6:0] ghr_committed;
    reg [6:0] ghr_spec;

    // Compute indexes
    wire [6:0] predict_index = predict_pc ^ ghr_spec;
    wire [6:0] train_index = train_pc ^ train_history;

    // Asynchronous PHT reads
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire [1:0] pht_train_entry = pht[train_index];

    // Prediction output: taken if MSB of counter is 1 and prediction is valid
    assign predict_taken = predict_valid && pht_predict_entry[1];

    // Prediction history output: immediate speculative history used for prediction
    assign predict_history = ghr_spec;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken)
                saturate_update = (state == 2'b11) ? 2'b11 : state + 2'b01;
            else
                saturate_update = (state == 2'b00) ? 2'b00 : state - 2'b01;
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to Weakly Not Taken (01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
            ghr_committed <= 7'b0;
            ghr_spec <= 7'b0;
        end else begin
            if (train_valid) begin
                // Update PHT entry indexed by train_index
                pht[train_index] <= saturate_update(pht_train_entry, train_taken);

                if (train_mispredicted) begin
                    // On misprediction, recover history registers to provided history
                    ghr_committed <= train_history;
                    ghr_spec <= train_history;
                end else begin
                    // On correct training, update committed history by shifting in actual outcome
                    ghr_committed <= {ghr_committed[5:0], train_taken};
                    // Speculative history not updated here (prediction path updates it)
                end
            end else if (predict_valid) begin
                // No training, prediction valid: update speculative history by appending prediction
                ghr_spec <= {ghr_spec[5:0], pht_predict_entry[1]};
            end
            // else no updates to histories or PHT
        end
    end

endmodule