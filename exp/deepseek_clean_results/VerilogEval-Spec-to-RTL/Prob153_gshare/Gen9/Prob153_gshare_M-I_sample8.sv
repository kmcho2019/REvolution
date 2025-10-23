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

    // Combined counter update function with direction control
    function [1:0] update_counter(input [1:0] cnt, input dir);
        update_counter = dir ? ((cnt == 2'b11) ? 2'b11 : cnt + 1)
                           : ((cnt == 2'b00) ? 2'b00 : cnt - 1);
    endfunction

    // Global history register
    reg [6:0] ghr;
    // Pattern history table
    reg [1:0] pht [0:127];
    
    // Pipeline registers for prediction path
    reg [6:0] predict_index_reg;
    reg predict_valid_reg;
    
    // Training index (combinational)
    wire [6:0] train_index = train_pc ^ train_history;
    
    // Prediction index calculation (pipelined)
    always @(posedge clk) begin
        predict_index_reg <= predict_pc ^ ghr;
        predict_valid_reg <= predict_valid;
    end
    
    // Prediction output (registered)
    always @(posedge clk) begin
        predict_taken <= predict_valid_reg ? pht[predict_index_reg][1] : 1'b0;
        predict_history <= ghr;
    end
    
    // Update PHT and GHR
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Parameterized reset
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // PHT update - gated by train_valid
            if (train_valid) begin
                pht[train_index] <= update_counter(pht[train_index], train_taken);
            end
            
            // GHR update - priority logic with gating
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid && !(train_valid && train_mispredicted)) begin
                ghr <= {ghr[5:0], pht[predict_pc ^ ghr][1]};  // Use current prediction
            end
        end
    end

endmodule