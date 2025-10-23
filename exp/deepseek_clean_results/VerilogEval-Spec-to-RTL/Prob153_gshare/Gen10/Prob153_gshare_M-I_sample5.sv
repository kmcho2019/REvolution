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

    // Function to update saturating counter
    function [1:0] update_counter;
        input [1:0] current;
        input taken;
        begin
            update_counter = taken ? 
                (current == 2'b11 ? 2'b11 : current + 1) :
                (current == 2'b00 ? 2'b00 : current - 1);
        end
    endfunction

    // 7-bit global history register
    reg [6:0] ghr;
    // 128-entry pattern history table (2-bit saturating counters)
    reg [1:0] pht [0:127];
    
    // Registered signals for pipelining
    reg [6:0] predict_index_reg;
    reg predict_valid_reg;
    
    // Shared XOR logic
    wire [6:0] xor_result = (predict_valid ? predict_pc : train_pc) ^ 
                            (predict_valid ? ghr : train_history);
    
    // Prediction index and output
    assign predict_index_reg = xor_result;
    assign predict_taken = pht[predict_index_reg][1];  // MSB determines prediction
    assign predict_history = ghr;

    // Training index
    wire [6:0] train_index = xor_result;

    // Clock gating for PHT updates
    wire pht_update_en = train_valid && ~areset;
    wire gclk;
    assign gclk = pht_update_en ? clk : 1'b0;

    // PHT update logic with clock gating
    always @(posedge gclk or posedge areset) begin
        if (areset) begin
            // Reset PHT - optimized to use parallel reset if available
            integer i;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // Update PHT counter
            pht[train_index] <= update_counter(pht[train_index], train_taken);
        end
    end

    // GHR update logic with power optimization
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
        end else begin
            // Training has priority over prediction
            casex ({train_valid && train_mispredicted, predict_valid})
                2'b1?: ghr <= {train_history[5:0], train_taken};
                2'b01: ghr <= {ghr[5:0], predict_taken};
                default: ghr <= ghr;  // No change when idle
            endcase
        end
    end

    // Pipeline register for prediction index
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_valid_reg <= 1'b0;
        end else begin
            predict_valid_reg <= predict_valid;
        end
    end

endmodule