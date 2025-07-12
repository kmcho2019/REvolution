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

    // Pattern History Table (PHT)
    reg [1:0] pht [0:127];
    reg [6:0] ghr;

    // Prediction index (combinational)
    wire [6:0] predict_index = predict_pc ^ ghr;

    // Training index (combinational)
    wire [6:0] train_index = train_pc ^ train_history;

    // Saturating counter update function
    function [1:0] next_counter;
        input [1:0] current;
        input taken;
        begin
            if (taken)
                next_counter = (current == 2'b11) ? 2'b11 : current + 1;
            else
                next_counter = (current == 2'b00) ? 2'b00 : current - 1;
        end
    endfunction

    // Current PHT state for training
    wire [1:0] current_counter = pht[train_index];
    wire [1:0] updated_counter = next_counter(current_counter, train_taken);

    // GHR update logic with clear priorities
    reg [6:0] next_ghr;
    always @(*) begin
        if (train_valid && train_mispredicted) begin
            next_ghr = {train_history[5:0], train_taken};
        end else if (train_valid) begin
            next_ghr = {ghr[5:0], train_taken};
        end else if (predict_valid) begin
            next_ghr = {ghr[5:0], pht[predict_index][1]};
        end else begin
            next_ghr = ghr;
        end
    end

    // Output logic
    always @(*) begin
        predict_taken = pht[predict_index][1];
        predict_history = ghr;
    end

    // Sequential logic
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly taken initial state
            end
        end else begin
            // Update PHT on training
            if (train_valid) begin
                pht[train_index] <= updated_counter;
            end

            // Update GHR
            ghr <= next_ghr;
        end
    end

endmodule