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

    // Banked PHT (2 banks of 64 entries)
    reg [1:0] pht_bank0 [0:63];
    reg [1:0] pht_bank1 [0:63];
    wire pht_bank_sel;
    
    // Single GHR with bypass
    reg [6:0] ghr;
    reg [6:0] ghr_bypass;
    reg use_bypass;
    
    // Prediction path
    wire [6:0] predict_index = predict_pc ^ (use_bypass ? ghr_bypass : ghr);
    wire predict_bank_sel = predict_index[6];
    wire [5:0] predict_bank_addr = predict_index[5:0];
    assign predict_taken = predict_bank_sel ? 
                         pht_bank1[predict_bank_addr][1] : 
                         pht_bank0[predict_bank_addr][1];
    assign predict_history = use_bypass ? ghr_bypass : ghr;
    
    // Training path
    wire [6:0] train_index = train_pc ^ train_history;
    wire train_bank_sel = train_index[6];
    wire [5:0] train_bank_addr = train_index[5:0];
    
    // Optimized counter update
    function [1:0] update_counter;
        input [1:0] current;
        input taken;
        begin
            update_counter = taken ? 
                (current == 2'b11 ? 2'b11 : current + 1) :
                (current == 2'b00 ? 2'b00 : current - 1);
        end
    endfunction
    
    // Clock gating for PHT
    reg pht_update_en;
    always @(*) begin
        pht_update_en = train_valid;
    end
    
    // GHR update logic
    always @(*) begin
        use_bypass = 1'b0;
        ghr_bypass = ghr;
        
        if (train_valid && train_mispredicted) begin
            use_bypass = 1'b1;
            ghr_bypass = {train_history[5:0], train_taken};
        end
        else if (predict_valid) begin
            use_bypass = 1'b0;  // Normal update through register
        end
    end
    
    // Initialize and update state
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly taken (2'b01)
            for (i = 0; i < 64; i = i + 1) begin
                pht_bank0[i] <= 2'b01;
                pht_bank1[i] <= 2'b01;
            end
            ghr <= 7'b0;
        end else begin
            // Update PHT for training (clock gated)
            if (pht_update_en) begin
                if (train_bank_sel)
                    pht_bank1[train_bank_addr] <= update_counter(pht_bank1[train_bank_addr], train_taken);
                else
                    pht_bank0[train_bank_addr] <= update_counter(pht_bank0[train_bank_addr], train_taken);
            end
            
            // Update GHR
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid && !(train_valid && train_mispredicted)) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule