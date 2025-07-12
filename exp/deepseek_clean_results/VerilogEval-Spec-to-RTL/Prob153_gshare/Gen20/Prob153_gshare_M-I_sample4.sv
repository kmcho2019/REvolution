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
    
    // Pipeline registers for prediction path
    reg predict_valid_reg;
    reg [6:0] predict_index_reg;
    reg [6:0] ghr_reg;

    // Prediction is now pipelined
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = predict_valid_reg ? pht[predict_index_reg][1] : 1'b0;
    assign predict_history = ghr_reg;

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;
    
    // PHT access enable signals
    wire pht_read_en = predict_valid && !train_valid;
    wire pht_write_en = train_valid;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT (parallel assignment)
            ghr <= 7'b0;
            ghr_reg <= 7'b0;
            predict_valid_reg <= 1'b0;
            pht <= '{default:2'b01};  // Parallel reset for all entries
            
        end else begin
            // Pipeline stage 1: Register prediction inputs
            predict_valid_reg <= predict_valid && !train_valid;
            predict_index_reg <= predict_index;
            ghr_reg <= ghr;
            
            // Handle training first (higher priority)
            if (train_valid) begin
                // Arithmetic PHT update (reduces LUT usage)
                if (train_taken) begin
                    pht[train_index] <= (pht[train_index] == 2'b11) ? 2'b11 : (pht[train_index] + 1);
                end else begin
                    pht[train_index] <= (pht[train_index] == 2'b00) ? 2'b00 : (pht[train_index] - 1);
                end

                // Update GHR for misprediction recovery
                if (train_mispredicted) begin
                    ghr <= {train_history[5:0], train_taken};
                end
            end
            
            // Handle prediction if no training or no misprediction recovery
            if (predict_valid && (!train_valid || !train_mispredicted)) begin
                ghr <= {ghr[5:0], pht[predict_index][1]};
            end
        end
    end

    // Clock gating for PHT (power optimization)
    always @(*) begin
        if (pht_read_en || pht_write_en) begin
            // PHT is accessed only when needed
        end
    end

endmodule