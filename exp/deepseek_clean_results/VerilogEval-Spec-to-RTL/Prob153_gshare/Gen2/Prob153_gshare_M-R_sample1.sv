module TopModule (
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    // 128-entry PHT of 2-bit saturating counters
    reg [1:0] pht [0:127];
    reg [6:0] ghr;

    // Function to update 2-bit saturating counter
    function [1:0] update_counter;
        input [1:0] current;
        input taken;
        begin
            update_counter = taken ? 
                (current == 2'b11 ? 2'b11 : current + 1) :
                (current == 2'b00 ? 2'b00 : current - 1);
        end
    endfunction

    // Prediction logic
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];
    assign predict_history = ghr;

    // Training logic
    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] current_counter = pht[train_index];
    wire [1:0] next_counter = update_counter(current_counter, train_taken);

    // GHR update logic with clear priority
    wire misprediction_update = train_valid & train_mispredicted;
    wire training_update = train_valid & ~train_mispredicted;
    wire prediction_update = predict_valid & ~(train_valid & train_mispredicted);

    wire [6:0] misprediction_ghr = {train_history[5:0], train_taken};
    wire [6:0] training_ghr = {ghr[5:0], train_taken};
    wire [6:0] prediction_ghr = {ghr[5:0], predict_taken};

    wire [6:0] next_ghr = misprediction_update ? misprediction_ghr :
                         training_update ? training_ghr :
                         prediction_update ? prediction_ghr :
                         ghr;

    // Sequential logic
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not taken
            end
        end else begin
            // Update PHT if training (next cycle effect)
            if (train_valid) begin
                pht[train_index] <= next_counter;
            end

            // Update GHR
            ghr <= next_ghr;
        end
    end

endmodule