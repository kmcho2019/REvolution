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
    wire [6:0] shared_ghr = (train_valid && train_mispredicted) ? train_history : ghr;
    wire [6:0] index = shared_xor ^ shared_ghr;

    // Prediction output
    assign predict_taken = pht[index][1];  // MSB determines prediction
    assign predict_history = ghr;

    // Training update signals
    wire do_train = train_valid && !(predict_valid && train_mispredicted);
    wire pht_update_en = do_train;
    wire [PHT_WIDTH-1:0] current_pht = pht[index];
    wire [PHT_WIDTH-1:0] updated_pht = 
        train_taken ? (current_pht == 2'b11 ? 2'b11 : current_pht + 1) :
                     (current_pht == 2'b00 ? 2'b00 : current_pht - 1);

    // Next GHR value - optimized logic
    wire ghr_update_en = predict_valid || (train_valid && train_mispredicted);
    wire [6:0] next_ghr = 
        (train_valid && train_mispredicted) ? {train_history[5:0], train_taken} :
        predict_valid ? {ghr[5:0], predict_taken} :
        ghr;

    // Sequential updates with clock gating
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT
            ghr <= 7'b0;
            for (integer j = 0; j < PHT_SIZE; j = j + 1) begin
                pht[j] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // Update GHR only when needed
            if (ghr_update_en) begin
                ghr <= next_ghr;
            end
            
            // Update PHT only when training occurs
            if (pht_update_en) begin
                pht[index] <= updated_pht;
            end
        end
    end

endmodule