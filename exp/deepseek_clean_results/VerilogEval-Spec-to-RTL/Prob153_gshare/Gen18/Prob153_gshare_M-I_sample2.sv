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

    // Gray-coded saturating counter update function (reduces switching power)
    function [1:0] update_counter;
        input [1:0] current;
        input taken;
        begin
            case (current)
                2'b00: update_counter = taken ? 2'b01 : 2'b00;
                2'b01: update_counter = taken ? 2'b11 : 2'b00;
                2'b11: update_counter = taken ? 2'b11 : 2'b10;
                2'b10: update_counter = taken ? 2'b11 : 2'b00;
            endcase
        end
    endfunction

    // Banked PHT (4 banks of 32 entries)
    reg [1:0] pht_bank0 [0:31];
    reg [1:0] pht_bank1 [0:31];
    reg [1:0] pht_bank2 [0:31];
    reg [1:0] pht_bank3 [0:31];
    
    // Global History Registers with clock gating
    reg [6:0] ghr;
    reg [6:0] next_ghr;
    wire ghr_update_en = train_valid || predict_valid;
    
    // Pipeline registers for timing optimization
    reg [6:0] predict_pc_reg;
    reg predict_valid_reg;
    always @(posedge clk) begin
        predict_pc_reg <= predict_pc;
        predict_valid_reg <= predict_valid;
    end
    
    // Bank selection and index calculation
    wire [6:0] raw_predict_idx = predict_pc_reg ^ ghr;
    wire [6:0] raw_train_idx = train_pc ^ train_history;
    
    // PHT access logic (banked)
    wire [1:0] predict_counter;
    assign predict_counter = 
        (raw_predict_idx[6:5] == 2'b00) ? pht_bank0[raw_predict_idx[4:0]] :
        (raw_predict_idx[6:5] == 2'b01) ? pht_bank1[raw_predict_idx[4:0]] :
        (raw_predict_idx[6:5] == 2'b10) ? pht_bank2[raw_predict_idx[4:0]] :
                                          pht_bank3[raw_predict_idx[4:0]];
    
    assign predict_taken = predict_counter[1];
    assign predict_history = ghr;
    
    // GHR update logic with priority
    always @(*) begin
        if (train_valid && train_mispredicted)
            next_ghr = {train_history[5:0], train_taken};
        else if (predict_valid_reg)
            next_ghr = {ghr[5:0], predict_taken};
        else
            next_ghr = ghr;
    end
    
    // Sequential updates with optimized reset
    parameter [1:0] PHT_INIT = 2'b01;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset PHT banks using parameter (more area-efficient)
            pht_bank0 <= '{default:PHT_INIT};
            pht_bank1 <= '{default:PHT_INIT};
            pht_bank2 <= '{default:PHT_INIT};
            pht_bank3 <= '{default:PHT_INIT};
            ghr <= 7'b0;
        end else begin
            // Clock-gated GHR update
            if (ghr_update_en)
                ghr <= next_ghr;
            
            // Banked PHT update
            if (train_valid) begin
                case (raw_train_idx[6:5])
                    2'b00: pht_bank0[raw_train_idx[4:0]] <= update_counter(pht_bank0[raw_train_idx[4:0]], train_taken);
                    2'b01: pht_bank1[raw_train_idx[4:0]] <= update_counter(pht_bank1[raw_train_idx[4:0]], train_taken);
                    2'b10: pht_bank2[raw_train_idx[4:0]] <= update_counter(pht_bank2[raw_train_idx[4:0]], train_taken);
                    2'b11: pht_bank3[raw_train_idx[4:0]] <= update_counter(pht_bank3[raw_train_idx[4:0]], train_taken);
                endcase
            end
        end
    end

endmodule