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

    // 7-bit global history register with clock enable
    reg [6:0] ghr;
    // 128-entry pattern history table (block RAM style)
    (* ram_style = "block" *) reg [1:0] pht [0:127];

    // Registered indices to break critical path
    reg [6:0] predict_index_reg;
    reg [6:0] train_index_reg;
    
    // PHT read/write controls
    wire pht_read_en = predict_valid;
    wire pht_write_en = train_valid;
    wire [6:0] pht_read_addr = predict_pc ^ ghr;
    wire [6:0] pht_write_addr = train_pc ^ train_history;
    
    // Pre-computed next PHT states
    wire [1:0] pht_next_inc = (pht[train_index_reg] == 2'b11) ? 2'b11 : pht[train_index_reg] + 1;
    wire [1:0] pht_next_dec = (pht[train_index_reg] == 2'b00) ? 2'b00 : pht[train_index_reg] - 1;

    // Prediction logic
    assign predict_taken = pht[predict_index_reg][1];  // MSB determines prediction
    assign predict_history = ghr;

    // Pipeline stage 1: Index computation
    always @(posedge clk) begin
        predict_index_reg <= pht_read_addr;
        train_index_reg <= pht_write_addr;
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // PHT update (write)
            if (pht_write_en) begin
                pht[train_index_reg] <= train_taken ? pht_next_inc : pht_next_dec;
            end

            // GHR update logic with priority
            casez ({train_valid, predict_valid})
                2'b1?: ghr <= train_mispredicted ? {train_history[5:0], train_taken} : ghr;
                2'b01: ghr <= {ghr[5:0], predict_taken};
                default: ghr <= ghr;
            endcase
        end
    end

endmodule