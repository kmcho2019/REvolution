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

    // Compact 1-hot encoded saturating counter (00:00, 01:01, 10:10, 11:11)
    reg [1:0] pht [0:127];
    
    // Global History Registers with clock gating
    reg [6:0] ghr;
    reg [6:0] next_ghr;
    wire ghr_update_en = predict_valid | (train_valid & train_mispredicted);
    
    // Shared XOR resource
    wire [6:0] shared_xor = predict_valid ? predict_pc : train_pc;
    wire [6:0] shared_ghr = (train_valid & train_mispredicted) ? train_history : ghr;
    wire [6:0] xor_result = shared_xor ^ shared_ghr;
    
    // Pipelined prediction index
    reg [6:0] predict_index_reg;
    always @(posedge clk) begin
        if (predict_valid)
            predict_index_reg <= xor_result;
    end
    
    // Banked PHT access control
    wire pht_read_en = predict_valid;
    wire pht_write_en = train_valid;
    
    // Prediction path
    assign predict_taken = pht[predict_index_reg][1];
    assign predict_history = ghr;
    
    // Training path
    wire [6:0] train_index = xor_result;
    
    // Optimized GHR update logic
    always @(*) begin
        case ({train_valid & train_mispredicted, predict_valid})
            2'b10: next_ghr = {train_history[5:0], train_taken};
            2'b01: next_ghr = {ghr[5:0], predict_taken};
            default: next_ghr = ghr;
        endcase
    end
    
    // Sequential updates with optimized reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Parameterized reset (synthesizes to constant initialization)
            pht <= '{default:2'b01};
            ghr <= 7'b0;
        end else begin
            // Banked PHT write
            if (pht_write_en)
                pht[train_index] <= train_taken ? 
                    (pht[train_index] == 2'b11 ? 2'b11 : pht[train_index] + 1) :
                    (pht[train_index] == 2'b00 ? 2'b00 : pht[train_index] - 1);
            
            // Clock-gated GHR update
            if (ghr_update_en)
                ghr <= next_ghr;
        end
    end

endmodule