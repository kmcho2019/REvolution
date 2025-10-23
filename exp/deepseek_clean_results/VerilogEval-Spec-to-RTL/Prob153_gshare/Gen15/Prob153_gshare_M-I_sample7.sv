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

    // 7-bit global history register
    reg [6:0] ghr;
    // 128-entry pattern history table (2-bit saturating counters)
    reg [1:0] pht [0:127];
    
    // Shared XOR logic
    wire [6:0] shared_xor = (train_valid) ? (train_pc ^ train_history) : (predict_pc ^ ghr);
    
    // Registered indices
    reg [6:0] train_index_reg;
    reg [6:0] predict_index_reg;
    
    // Prediction logic
    assign predict_taken = pht[predict_index_reg][1];
    assign predict_history = ghr;
    
    // Training signals
    wire pht_write_en = train_valid && !areset;
    wire [1:0] new_counter_value;
    wire counter_will_change;
    
    // Clock gating signals
    wire pht_clk_en = pht_write_en && counter_will_change;
    wire pht_clk;
    
    // Determine new counter value and if it will change
    assign new_counter_value = train_taken ? 
                             ((pht[train_index_reg] == 2'b11) ? 2'b11 : pht[train_index_reg] + 1) :
                             ((pht[train_index_reg] == 2'b00) ? 2'b00 : pht[train_index_reg] - 1);
    assign counter_will_change = (new_counter_value != pht[train_index_reg]);
    
    // Clock gating for PHT
    assign pht_clk = pht_clk_en ? clk : 1'b0;
    
    // Index pipeline registers
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            train_index_reg <= 7'b0;
            predict_index_reg <= 7'b0;
        end else begin
            train_index_reg <= shared_xor;
            predict_index_reg <= shared_xor;
        end
    end
    
    // PHT update (clock gated)
    always @(posedge pht_clk or posedge areset) begin
        if (areset) begin
            // Initialize only first 8 entries (rest will be initialized on first use)
            for (integer i = 0; i < 8; i = i + 1) begin
                pht[i] <= 2'b01;
            end
        end else if (pht_write_en) begin
            pht[train_index_reg] <= new_counter_value;
        end
    end
    
    // GHR update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
        end else begin
            // Training has priority
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid && (!train_valid || !train_mispredicted)) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end
    
    // Lazy initialization for remaining PHT entries
    always @(posedge clk) begin
        if (!areset && predict_valid && pht[predict_index_reg] === 2'bx) begin
            pht[predict_index_reg] <= 2'b01;
        end
    end

endmodule