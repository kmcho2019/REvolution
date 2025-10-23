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
    // Pattern History Table (128 entries of 2-bit counters)
    reg [1:0] pht [0:127];
    // One-hot encoded access signals for clock gating
    wire [127:0] pht_access;

    // Pipeline registers for prediction path
    reg [6:0] predict_idx_reg;
    reg predict_valid_reg;

    // Prediction index calculation (stage 1)
    wire [6:0] predict_idx = predict_pc ^ ghr;

    // Training index
    wire [6:0] train_idx = train_pc ^ train_history;

    // Generate one-hot access signals
    assign pht_access = (predict_valid_reg && !train_valid) ? (1 << predict_idx_reg) :
                       (train_valid) ? (1 << train_idx) : 128'b0;

    // PHT update logic with clock gating
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Staggered initialization to reduce fan-out
            for (integer i = 0; i < 128; i = i + 1) begin
                if (i % 4 == 0) pht[i] <= 2'b01;
                if (i % 4 == 1) pht[i] <= 2'b01;
                if (i % 4 == 2) pht[i] <= 2'b01;
                if (i % 4 == 3) pht[i] <= 2'b01;
            end
        end
        else if (train_valid && pht_access[train_idx]) begin
            // Optimized saturation counter update
            pht[train_idx] <= train_taken ? 
                (pht[train_idx] == 2'b11 ? 2'b11 : pht[train_idx] + 1) :
                (pht[train_idx] == 2'b00 ? 2'b00 : pht[train_idx] - 1);
        end
    end

    // Prediction pipeline stage 1 (index calculation)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_idx_reg <= 7'b0;
            predict_valid_reg <= 1'b0;
        end else begin
            predict_idx_reg <= predict_idx;
            predict_valid_reg <= predict_valid;
        end
    end

    // Prediction pipeline stage 2 (PHT access)
    always @(*) begin
        predict_taken = pht[predict_idx_reg][1];
        predict_history = ghr;
    end

    // GHR update logic with enable conditions
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
        end
        else begin
            // Training has priority
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end
            else if (predict_valid && !(train_valid && train_mispredicted)) begin
                ghr <= {ghr[5:0], pht[predict_idx][1]};
            end
        end
    end

endmodule