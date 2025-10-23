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

    // Pattern History Table (128 entries of 2-bit counters)
    reg [1:0] pht [0:127];
    
    // Global History Register
    reg [6:0] ghr;

    // Prediction index and output
    wire [6:0] pred_index = predict_pc ^ ghr;
    assign predict_taken = pht[pred_index][1];
    assign predict_history = ghr;

    // Training index calculation
    wire [6:0] train_index = train_pc ^ train_history;

    // Next state signals
    reg [6:0] next_ghr;
    reg [1:0] next_pht [0:127];

    // Counter update function
    function [1:0] update_counter;
        input [1:0] current;
        input taken;
        begin
            case (current)
                2'b00: update_counter = taken ? 2'b01 : 2'b00;
                2'b01: update_counter = taken ? 2'b10 : 2'b00;
                2'b10: update_counter = taken ? 2'b11 : 2'b01;
                2'b11: update_counter = taken ? 2'b11 : 2'b10;
            endcase
        end
    endfunction

    // Next state calculation
    integer i;
    always @(*) begin
        // Default: maintain current state
        next_ghr = ghr;
        for (i = 0; i < 128; i = i + 1)
            next_pht[i] = pht[i];

        // Training has priority over prediction
        if (train_valid) begin
            // Update PHT entry
            next_pht[train_index] = update_counter(pht[train_index], train_taken);
            
            // Update GHR - misprediction recovery takes precedence
            if (train_mispredicted)
                next_ghr = {train_history[5:0], train_taken};
            else
                next_ghr = {ghr[5:0], train_taken};
        end
        else if (predict_valid) begin
            // Only update GHR if not training
            next_ghr = {ghr[5:0], predict_taken};
        end
    end

    // State update on clock edge
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly taken
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
            ghr <= 7'b0;
        end else begin
            // Update all state synchronously
            ghr <= next_ghr;
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= next_pht[i];
        end
    end

endmodule