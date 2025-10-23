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

    // Function to update saturating counter (optimized version)
    function [1:0] update_counter;
        input [1:0] current;
        input taken;
        begin
            update_counter = taken ? ((current == 2'b11) ? 2'b11 : current + 1) :
                                   ((current == 2'b00) ? 2'b00 : current - 1);
        end
    endfunction

    // Pattern History Table (128 entries, banked into 8 banks of 16 entries)
    reg [1:0] pht [0:127];
    reg [7:0] pht_bank_en; // One enable per bank
    
    // Global History Registers
    reg [6:0] ghr;          // Current prediction GHR
    reg [6:0] next_ghr;     // Next GHR value
    wire ghr_update_en;     // Clock gating signal
    
    // Shared XOR resources
    wire [6:0] predict_xor = predict_pc ^ ghr;
    wire [6:0] train_xor = train_pc ^ train_history;
    
    // Pipeline register for predict index (improves timing)
    reg [6:0] predict_index_reg;
    always @(posedge clk) begin
        if (predict_valid)
            predict_index_reg <= predict_xor;
    end
    
    // Bank enables for PHT (power optimization)
    always @(*) begin
        pht_bank_en = 8'b0;
        if (predict_valid) pht_bank_en[predict_xor[6:4]] = 1'b1;
        if (train_valid) pht_bank_en[train_xor[6:4]] = 1'b1;
    end
    
    // Prediction path (combinational)
    assign predict_taken = pht[predict_index_reg][1];  // MSB determines prediction
    assign predict_history = ghr;
    
    // Training path (combinational)
    wire [6:0] train_index = train_xor;
    
    // GHR update logic with clock gating
    assign ghr_update_en = predict_valid | (train_valid & train_mispredicted);
    always @(*) begin
        if (train_valid && train_mispredicted)
            next_ghr = {train_history[5:0], train_taken};
        else if (predict_valid)
            next_ghr = {ghr[5:0], predict_taken};
        else
            next_ghr = ghr;
    end
    
    // Sequential updates with clock gating
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly taken (2'b01) using parameterized reset
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
            ghr <= 7'b0;
            predict_index_reg <= 7'b0;
        end else begin
            // Update PHT if training (only enabled banks consume power)
            if (train_valid && pht_bank_en[train_index[6:4]])
                pht[train_index] <= update_counter(pht[train_index], train_taken);
            
            // Update GHR only when needed (clock gating)
            if (ghr_update_en)
                ghr <= next_ghr;
        end
    end

endmodule