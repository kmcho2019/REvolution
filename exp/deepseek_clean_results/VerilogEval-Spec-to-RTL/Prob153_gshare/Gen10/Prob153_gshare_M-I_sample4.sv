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

    // Compact saturating counter encoding (1-hot)
    // 00: 0001 (strong not taken)
    // 01: 0010 (weak not taken)
    // 10: 0100 (weak taken)
    // 11: 1000 (strong taken)
    reg [3:0] pht [0:127];
    parameter [3:0] PHT_INIT = 4'b0100; // Initialize to weak taken
    
    // Global History Registers
    reg [6:0] ghr;
    reg [6:0] next_ghr;
    wire ghr_update_en = predict_valid | (train_valid & train_mispredicted);
    
    // Pipelined XOR for timing
    reg [6:0] predict_index_reg;
    wire [6:0] predict_index = predict_pc ^ ghr;
    
    // Banked PHT access control
    wire pht_write_en = train_valid & ~areset;
    wire [6:0] pht_write_addr = train_pc ^ train_history;
    
    // Prediction path
    assign predict_taken = pht[predict_index_reg][3] | pht[predict_index_reg][2]; // 11 or 10
    assign predict_history = ghr;
    
    // Training path
    function [3:0] update_counter;
        input [3:0] current;
        input taken;
        begin
            if (taken)
                update_counter = {current[2:0], 1'b0} | (current[3] ? 4'b1000 : 4'b0000);
            else
                update_counter = {1'b0, current[3:1]} | (current[0] ? 4'b0001 : 4'b0000);
        end
    endfunction
    
    // GHR update logic with priority
    always @(*) begin
        if (train_valid & train_mispredicted)
            next_ghr = {train_history[5:0], train_taken};
        else if (predict_valid)
            next_ghr = {ghr[5:0], predict_taken};
        else
            next_ghr = ghr;
    end
    
    // Sequential updates with optimizations
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Parameter-based reset
            for (integer i = 0; i < 128; i++) begin
                pht[i] <= PHT_INIT;
            end
            ghr <= 7'b0;
            predict_index_reg <= 7'b0;
        end else begin
            // Pipeline register for XOR
            if (predict_valid)
                predict_index_reg <= predict_index;
            
            // Clock-gated GHR update
            if (ghr_update_en)
                ghr <= next_ghr;
            
            // Banked PHT write
            if (pht_write_en)
                pht[pht_write_addr] <= update_counter(pht[pht_write_addr], train_taken);
        end
    end

endmodule