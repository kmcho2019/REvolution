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

    // 7-bit global history register with clock gating
    reg [6:0] ghr;
    // 64-entry pattern history table (2-bit saturating counters)
    reg [1:0] pht [0:63];
    
    // Improved index hashing (7-bit output from 7-bit inputs)
    function [6:0] hash_index;
        input [6:0] pc, history;
        begin
            hash_index = {pc[6:4] ^ history[2:0], 
                         pc[3:0] ^ history[6:3]};
        end
    endfunction

    // Prediction path (registered output)
    wire [6:0] predict_index = hash_index(predict_pc, ghr);
    reg [1:0] pht_predict_out;
    
    always @(*) begin
        if (predict_valid) begin
            pht_predict_out = pht[predict_index];
            predict_taken = pht_predict_out[1];
        end else begin
            pht_predict_out = 2'b0;
            predict_taken = 1'b0;
        end
        predict_history = ghr;
    end

    // Training path
    wire [6:0] train_index = hash_index(train_pc, train_history);
    reg [1:0] pht_train_out;
    
    // Simplified saturating counter update
    always @(*) begin
        if (train_valid) begin
            pht_train_out = pht[train_index];
            case ({pht_train_out, train_taken})
                3'b000: pht_train_out = 2'b00;
                3'b001: pht_train_out = 2'b01;
                3'b010: pht_train_out = 2'b01;
                3'b011: pht_train_out = 2'b10;
                3'b100: pht_train_out = 2'b01;
                3'b101: pht_train_out = 2'b10;
                3'b110: pht_train_out = 2'b11;
                3'b111: pht_train_out = 2'b11;
            endcase
        end
    end

    // GHR update logic with clock gating
    wire ghr_update = (train_valid && train_mispredicted) || predict_valid;
    wire [6:0] next_ghr = (train_valid && train_mispredicted) ? 
                         {train_history[5:0], train_taken} : 
                         {ghr[5:0], pht_predict_out[1]};

    // Sequential updates with clock gating
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (integer i = 0; i < 64; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // Update PHT if training
            if (train_valid) begin
                pht[train_index] <= pht_train_out;
            end
            
            // Update GHR only when needed
            if (ghr_update) begin
                ghr <= next_ghr;
            end
        end
    end

endmodule