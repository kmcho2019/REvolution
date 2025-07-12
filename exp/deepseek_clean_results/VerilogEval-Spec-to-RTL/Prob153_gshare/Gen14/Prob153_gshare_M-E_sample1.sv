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
    parameter NUM_BANKS = 4;
    parameter BANK_SIZE = 32;
    parameter PHT_WIDTH = 2;

    // History registers
    reg [6:0] committed_ghr;  // Committed global history
    reg [6:0] speculative_ghr; // Speculative history for predictions
    
    // Banked PHT structure
    reg [PHT_WIDTH-1:0] pht_bank0 [0:BANK_SIZE-1];
    reg [PHT_WIDTH-1:0] pht_bank1 [0:BANK_SIZE-1];
    reg [PHT_WIDTH-1:0] pht_bank2 [0:BANK_SIZE-1];
    reg [PHT_WIDTH-1:0] pht_bank3 [0:BANK_SIZE-1];

    // Pre-computed prediction index (registered)
    reg [6:0] predict_index_reg;
    wire [6:0] predict_index = predict_pc ^ speculative_ghr;
    
    // Bank selection and access
    wire [1:0] predict_bank = predict_index[1:0];
    wire [4:0] predict_bank_addr = predict_index[6:2];
    
    wire [1:0] train_bank = train_pc[1:0] ^ train_history[1:0];
    wire [4:0] train_bank_addr = train_pc[6:2] ^ train_history[6:2];
    
    // PHT read mux
    reg [PHT_WIDTH-1:0] pht_read_data;
    always @(*) begin
        case (predict_bank)
            2'b00: pht_read_data = pht_bank0[predict_bank_addr];
            2'b01: pht_read_data = pht_bank1[predict_bank_addr];
            2'b10: pht_read_data = pht_bank2[predict_bank_addr];
            2'b11: pht_read_data = pht_bank3[predict_bank_addr];
        endcase
    end
    
    assign predict_taken = pht_read_data[1];
    assign predict_history = speculative_ghr;

    // Training update logic
    wire [PHT_WIDTH-1:0] curr_pht;
    wire [PHT_WIDTH-1:0] new_pht;
    
    // Current PHT value mux
    always @(*) begin
        case (train_bank)
            2'b00: curr_pht = pht_bank0[train_bank_addr];
            2'b01: curr_pht = pht_bank1[train_bank_addr];
            2'b10: curr_pht = pht_bank2[train_bank_addr];
            2'b11: curr_pht = pht_bank3[train_bank_addr];
        endcase
    end
    
    // Lazy update - only change if not saturated
    assign new_pht = train_taken ? 
                    (curr_pht == 2'b11 ? 2'b11 : curr_pht + 1) :
                    (curr_pht == 2'b00 ? 2'b00 : curr_pht - 1);

    // History update logic
    wire [6:0] next_committed_ghr = 
        train_mispredicted ? {train_history[5:0], train_taken} :
        {committed_ghr[5:0], (train_valid ? train_taken : committed_ghr[6])};
    
    wire [6:0] next_speculative_ghr = 
        (train_valid && train_mispredicted) ? next_committed_ghr :
        predict_valid ? {speculative_ghr[5:0], predict_taken} :
        speculative_ghr;

    // Sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            committed_ghr <= 7'b0;
            speculative_ghr <= 7'b0;
            predict_index_reg <= 7'b0;
            
            // Initialize all PHT banks
            for (integer i = 0; i < BANK_SIZE; i = i + 1) begin
                pht_bank0[i] <= 2'b01;
                pht_bank1[i] <= 2'b01;
                pht_bank2[i] <= 2'b01;
                pht_bank3[i] <= 2'b01;
            end
        end else begin
            // Register prediction index for next cycle
            predict_index_reg <= predict_index;
            
            // Update history registers
            committed_ghr <= next_committed_ghr;
            speculative_ghr <= next_speculative_ghr;
            
            // Update PHT banks if training
            if (train_valid) begin
                case (train_bank)
                    2'b00: pht_bank0[train_bank_addr] <= new_pht;
                    2'b01: pht_bank1[train_bank_addr] <= new_pht;
                    2'b10: pht_bank2[train_bank_addr] <= new_pht;
                    2'b11: pht_bank3[train_bank_addr] <= new_pht;
                endcase
            end
        end
    end

endmodule