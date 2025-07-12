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

    // Dual-ported PHT implementation
    reg [1:0] pht [0:127];
    reg [6:0] ghr;
    reg [6:0] shadow_ghr;  // For misprediction recovery

    // Prediction path (combinational)
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];  // MSB = prediction
    assign predict_history = ghr;  // Current GHR state

    // Training path
    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] current_counter = pht[train_index];
    
    // Enhanced saturating counter with bounds checking
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

    wire [1:0] updated_counter = next_counter(current_counter, train_taken);

    // GHR update logic with clear priorities
    reg [6:0] next_ghr;
    always @(*) begin
        casez ({train_valid && train_mispredicted, train_valid, predict_valid})
            3'b1??: next_ghr = {train_history[5:0], train_taken};  // Misprediction recovery
            3'b01?: next_ghr = {ghr[5:0], train_taken};            // Training update
            3'b001: next_ghr = {ghr[5:0], predict_taken};          // Prediction update
            default: next_ghr = ghr;                               // No change
        endcase
    end

    // Sequential logic
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            shadow_ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken initial state
            end
        end else begin
            // Update PHT on training (next cycle effect)
            if (train_valid) begin
                pht[train_index] <= updated_counter;
            end

            // Update shadow GHR on misprediction
            if (train_valid && train_mispredicted) begin
                shadow_ghr <= {train_history[5:0], train_taken};
            end

            // Main GHR update
            ghr <= next_ghr;
        end
    end

endmodule