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

    parameter PHT_SIZE = 128;
    parameter PHT_WIDTH = 2;

    // 7-bit global history register
    reg [6:0] ghr;
    // Pattern history table (2-bit saturating counters)
    reg [PHT_WIDTH-1:0] pht [0:PHT_SIZE-1];

    // Shared XOR for index calculation
    wire [6:0] shared_xor = predict_valid ? predict_pc : train_pc;
    wire [6:0] shared_ghr = predict_valid ? ghr : train_history;
    wire [6:0] index = shared_xor ^ shared_ghr;

    // Prediction output
    assign predict_taken = pht[index][1];  // MSB determines prediction
    assign predict_history = ghr;

    // Training logic
    wire pht_update_en = train_valid && 
                        ((train_taken && (pht[index] != 2'b11)) || 
                         (!train_taken && (pht[index] != 2'b00)));
    wire [PHT_WIDTH-1:0] pht_update_val = train_taken ? (pht[index] + 1) : (pht[index] - 1);

    // Next GHR value - optimized to avoid redundant updates
    wire [6:0] next_ghr;
    wire ghr_update = (train_valid && train_mispredicted) || 
                     (predict_valid && !(train_valid && train_mispredicted));
    wire new_bit = train_valid ? train_taken : predict_taken;
    assign next_ghr = ghr_update ? {ghr[5:0], new_bit} : ghr;

    // Sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT
            ghr <= 7'b0;
            for (integer j = 0; j < PHT_SIZE; j = j + 1) begin
                pht[j] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // Update GHR only when needed
            if (ghr_update) begin
                ghr <= next_ghr;
            end
            
            // Update PHT only when needed
            if (pht_update_en) begin
                pht[index] <= pht_update_val;
            end
        end
    end

endmodule