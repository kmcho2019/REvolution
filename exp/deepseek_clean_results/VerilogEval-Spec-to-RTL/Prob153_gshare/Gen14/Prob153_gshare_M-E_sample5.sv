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

    // Dual GHR implementation
    reg [6:0] committed_ghr;  // Committed history
    reg [6:0] speculative_ghr; // Speculative history
    
    // Banked PHT (even and odd banks)
    reg [1:0] pht_even [0:63];  // Even indices
    reg [1:0] pht_odd [0:63];   // Odd indices
    
    // Pipeline registers
    reg [6:0] stage1_pc;
    reg stage1_valid;
    reg [6:0] stage1_index;
    reg stage1_bank;
    
    // Combinational outputs
    assign predict_taken = stage1_valid ? 
                         (stage1_bank ? pht_odd[stage1_index[5:0]][1] : 
                                       pht_even[stage1_index[5:0]][1]) : 1'b0;
    assign predict_history = committed_ghr;

    // Index calculation (stage 0)
    wire [6:0] current_index = predict_pc ^ committed_ghr;
    wire current_bank = current_index[0];
    
    // Training index calculation
    wire [6:0] train_index = train_pc ^ train_history;
    wire train_bank = train_index[0];
    
    // PHT update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT and GHRs
            for (integer i = 0; i < 64; i = i + 1) begin
                pht_even[i] <= 2'b01;
                pht_odd[i] <= 2'b01;
            end
            committed_ghr <= 7'b0;
            speculative_ghr <= 7'b0;
            stage1_valid <= 1'b0;
        end else begin
            // Pipeline stage 1 (PHT lookup)
            stage1_pc <= predict_pc;
            stage1_valid <= predict_valid;
            stage1_index <= current_index;
            stage1_bank <= current_bank;
            
            // PHT updates (banked writes)
            if (train_valid) begin
                if (train_bank) begin
                    pht_odd[train_index[6:1]] <= train_taken ? 
                        (pht_odd[train_index[6:1]] == 2'b11 ? 2'b11 : 
                         pht_odd[train_index[6:1]] + 1) :
                        (pht_odd[train_index[6:1]] == 2'b00 ? 2'b00 : 
                         pht_odd[train_index[6:1]] - 1);
                end else begin
                    pht_even[train_index[6:1]] <= train_taken ? 
                        (pht_even[train_index[6:1]] == 2'b11 ? 2'b11 : 
                         pht_even[train_index[6:1]] + 1) :
                        (pht_even[train_index[6:1]] == 2'b00 ? 2'b00 : 
                         pht_even[train_index[6:1]] - 1);
                end
            end
            
            // GHR updates with priority to training
            if (train_valid && train_mispredicted) begin
                committed_ghr <= {train_history[5:0], train_taken};
                speculative_ghr <= {train_history[5:0], train_taken};
            end else if (train_valid) begin
                committed_ghr <= {committed_ghr[5:0], train_taken};
                speculative_ghr <= {committed_ghr[5:0], train_taken};
            end else if (predict_valid) begin
                speculative_ghr <= {speculative_ghr[5:0], predict_taken};
            end
        end
    end

endmodule