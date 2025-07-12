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
    parameter INITIAL_PHT_VAL = 2'b01;  // Weakly not-taken

    // Global history register
    reg [6:0] ghr;

    // Pattern history table
    reg [PHT_WIDTH-1:0] pht [0:PHT_SIZE-1];

    // Pipelined prediction index (registered to break critical path)
    reg [6:0] predict_index_reg;
    wire [6:0] predict_index = predict_pc ^ ghr;

    // Prediction outputs
    assign predict_taken = predict_valid ? pht[predict_index_reg][1] : 1'b0;
    assign predict_history = ghr;

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;

    // PHT update logic (only updates when counter would change)
    wire pht_update_en;
    wire [PHT_WIDTH-1:0] pht_update_val;
    
    assign pht_update_en = train_valid && 
                         ((train_taken && (pht[train_index] != 2'b11)) ||
                         (!train_taken && (pht[train_index] != 2'b00)));
    
    assign pht_update_val = train_taken ? 
                          (pht[train_index] + 1) : 
                          (pht[train_index] - 1);

    // GHR next state logic
    wire [6:0] next_ghr;
    assign next_ghr = (train_valid && train_mispredicted) ? 
                     {train_history[5:0], train_taken} :
                     (predict_valid) ? 
                     {ghr[5:0], predict_taken} :
                     ghr;

    // Sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT
            ghr <= 7'b0;
            predict_index_reg <= 7'b0;
            for (integer i = 0; i < PHT_SIZE; i = i + 1) begin
                pht[i] <= INITIAL_PHT_VAL;
            end
        end else begin
            // Pipeline stage: register prediction index
            if (predict_valid) begin
                predict_index_reg <= predict_index;
            end

            // Update GHR
            ghr <= next_ghr;
            
            // Update PHT (only when enabled)
            if (pht_update_en) begin
                pht[train_index] <= pht_update_val;
            end
        end
    end

endmodule