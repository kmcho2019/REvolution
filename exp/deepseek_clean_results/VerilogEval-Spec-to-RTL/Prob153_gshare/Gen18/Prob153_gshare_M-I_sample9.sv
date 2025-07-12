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

    // Global History Register
    reg [6:0] ghr;
    
    // Banked Pattern History Table (64 entries per bank)
    reg [1:0] pht_0 [0:63];  // Even indices
    reg [1:0] pht_1 [0:63];  // Odd indices
    
    // Registered prediction index
    reg [6:0] predict_idx_reg;
    wire [6:0] predict_idx = predict_pc ^ ghr;
    
    // Training index
    wire [6:0] train_idx = train_pc ^ train_history;
    wire train_bank_sel = train_idx[0];
    wire [5:0] train_addr = train_idx[6:1];
    
    // Clock gating signals
    wire pht_0_clk_en = train_valid && !train_bank_sel;
    wire pht_1_clk_en = train_valid && train_bank_sel;
    wire pht_0_clk = pht_0_clk_en ? clk : 1'b0;
    wire pht_1_clk = pht_1_clk_en ? clk : 1'b0;
    
    // Prediction path pipeline
    always @(posedge clk) begin
        predict_idx_reg <= predict_idx;
        predict_history <= ghr;
    end
    
    // Select appropriate PHT bank for prediction
    always @(*) begin
        if (predict_idx_reg[0])
            predict_taken = pht_1[predict_idx_reg[6:1]][1];
        else
            predict_taken = pht_0[predict_idx_reg[6:1]][1];
    end
    
    // PHT update logic - Bank 0 (even indices)
    always @(posedge pht_0_clk or posedge areset) begin
        if (areset) begin
            for (integer i = 0; i < 64; i = i + 1)
                if (i < 32) pht_0[i] <= 2'b01;  // Staggered init
        end
        else begin
            // Optimized saturation counter update
            reg [1:0] current = pht_0[train_addr];
            pht_0[train_addr] <= train_taken ? 
                (current == 2'b11 ? 2'b11 : current + 1) :
                (current == 2'b00 ? 2'b00 : current - 1);
        end
    end
    
    // PHT update logic - Bank 1 (odd indices)
    always @(posedge pht_1_clk or posedge areset) begin
        if (areset) begin
            for (integer i = 0; i < 64; i = i + 1)
                if (i >= 32) pht_1[i] <= 2'b01;  // Staggered init
        end
        else begin
            // Optimized saturation counter update
            reg [1:0] current = pht_1[train_addr];
            pht_1[train_addr] <= train_taken ? 
                (current == 2'b11 ? 2'b11 : current + 1) :
                (current == 2'b00 ? 2'b00 : current - 1);
        end
    end
    
    // Simplified GHR update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
        end
        else if (train_valid && train_mispredicted) begin
            ghr <= {train_history[5:0], train_taken};
        end
        else if (predict_valid) begin
            ghr <= {ghr[5:0], predict_taken};
        end
    end

endmodule