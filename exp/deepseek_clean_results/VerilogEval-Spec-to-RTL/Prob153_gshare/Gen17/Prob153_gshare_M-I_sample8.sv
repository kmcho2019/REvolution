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
    // 128-entry pattern history table (inferred BRAM)
    (* ram_style = "block" *) reg [1:0] pht [0:127];

    // Registered indices
    reg [6:0] predict_index_reg;
    reg [6:0] train_index_reg;

    // Pre-computed PHT next states
    wire [1:0] pht_next_inc = (pht[train_index_reg] == 2'b11) ? 2'b11 : (pht[train_index_reg] + 1);
    wire [1:0] pht_next_dec = (pht[train_index_reg] == 2'b00) ? 2'b00 : (pht[train_index_reg] - 1);

    // Index computation (combinational)
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // PHT read data
    reg [1:0] pht_predict_data;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
            predict_index_reg <= 7'b0;
            train_index_reg <= 7'b0;
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            // Register indices
            predict_index_reg <= predict_index;
            train_index_reg <= train_index;

            // Handle training first (higher priority)
            if (train_valid) begin
                // Update PHT counter
                if (train_taken) begin
                    pht[train_index_reg] <= pht_next_inc;
                end else begin
                    pht[train_index_reg] <= pht_next_dec;
                end

                // Update GHR for misprediction recovery
                if (train_mispredicted) begin
                    ghr <= {train_history[5:0], train_taken};
                end
            end
            
            // Handle prediction if no training or no misprediction recovery
            if (predict_valid && (!train_valid || !train_mispredicted)) begin
                ghr <= {ghr[5:0], pht_predict_data[1]};
            end

            // Register outputs
            predict_taken <= pht_predict_data[1];
            predict_history <= ghr;
        end
    end

    // PHT read (combinational)
    always @(*) begin
        pht_predict_data = pht[predict_index_reg];
    end

endmodule