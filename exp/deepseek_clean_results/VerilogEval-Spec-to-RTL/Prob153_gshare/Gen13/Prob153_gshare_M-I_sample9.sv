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

    // 7-bit global history register with gated updates
    reg [6:0] ghr;
    // 128-entry pattern history table (block RAM style)
    (* ram_style = "block" *) reg [1:0] pht [0:127];
    
    // Pipelined index computation
    reg [6:0] predict_index_reg;
    reg [6:0] train_index_reg;
    
    // Pre-computed next states for PHT
    wire [1:0] pht_next_inc = (pht[train_index_reg] == 2'b11) ? 2'b11 : pht[train_index_reg] + 1;
    wire [1:0] pht_next_dec = (pht[train_index_reg] == 2'b00) ? 2'b00 : pht[train_index_reg] - 1;
    
    // PHT access control
    wire pht_write_en = train_valid;
    wire [6:0] pht_write_addr = train_index_reg;
    wire [1:0] pht_write_data = train_taken ? pht_next_inc : pht_next_dec;
    
    // GHR update logic
    wire ghr_update = predict_valid && (!train_valid || !train_mispredicted);
    wire [6:0] next_ghr = train_mispredicted ? {train_history[5:0], train_taken} : 
                         ghr_update ? {ghr[5:0], predict_taken} : ghr;

    // Index computation pipeline
    always @(posedge clk) begin
        predict_index_reg <= predict_pc ^ ghr;
        train_index_reg <= train_pc ^ train_history;
    end

    // Prediction pipeline
    always @(posedge clk) begin
        predict_taken <= pht[predict_index_reg][1];
        predict_history <= ghr;
    end

    // Main sequential logic
    always @(posedge clk) begin
        if (areset) begin
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // Update PHT
            if (pht_write_en) begin
                pht[pht_write_addr] <= pht_write_data;
            end
            
            // Update GHR
            ghr <= next_ghr;
        end
    end

endmodule