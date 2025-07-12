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

    // Parameters
    localparam PHT_SIZE = 128;
    localparam PHT_WIDTH = 2;
    
    // Storage elements
    reg [6:0] ghr;
    reg [PHT_WIDTH-1:0] pht [0:PHT_SIZE-1];
    
    // Shared XOR for prediction and training
    wire [6:0] xor_result = predict_valid ? (predict_pc ^ ghr) : (train_pc ^ train_history);
    
    // Prediction outputs
    assign predict_taken = pht[xor_result][1];
    assign predict_history = ghr;
    
    // Training logic
    wire pht_update_en = train_valid;
    wire [PHT_WIDTH-1:0] current_pht_entry = pht[xor_result];
    wire [PHT_WIDTH-1:0] updated_pht_entry;
    
    // Saturating counter update logic
    assign updated_pht_entry = 
        (train_taken && (current_pht_entry != 2'b11)) ? current_pht_entry + 1 :
        (!train_taken && (current_pht_entry != 2'b00)) ? current_pht_entry - 1 :
        current_pht_entry;
    
    // GHR update logic
    wire ghr_update = train_valid ? train_mispredicted : predict_valid;
    wire [6:0] next_ghr = ghr_update ? 
                         (train_valid ? {train_history[5:0], train_taken} : {ghr[5:0], predict_taken}) : 
                         ghr;
    
    // Sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize GHR and PHT
            ghr <= 7'b0;
            for (integer i = 0; i < PHT_SIZE; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // Update GHR
            ghr <= next_ghr;
            
            // Update PHT if training
            if (pht_update_en) begin
                pht[xor_result] <= updated_pht_entry;
            end
        end
    end

endmodule