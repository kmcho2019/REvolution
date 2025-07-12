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

    // History registers
    reg [6:0] committed_ghr;
    reg [6:0] speculative_ghr;
    
    // PHT memory (128 entries)
    reg [1:0] pht [0:127];
    
    // Training buffer
    reg train_valid_delayed;
    reg train_taken_delayed;
    reg [6:0] train_index_delayed;
    
    // Prediction index computed in previous cycle
    reg [6:0] predict_index_reg;
    wire [6:0] next_predict_index = predict_pc ^ speculative_ghr;
    
    // Output assignments
    assign predict_taken = pht[predict_index_reg][1];
    assign predict_history = speculative_ghr;
    
    // PHT update logic (delayed by 1 cycle)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            for (integer i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
            train_valid_delayed <= 0;
        end else begin
            // Buffer training requests
            train_valid_delayed <= train_valid;
            train_taken_delayed <= train_taken;
            train_index_delayed <= train_pc ^ train_history;
            
            // Delayed PHT update
            if (train_valid_delayed) begin
                // Optimized saturating counter update
                case (pht[train_index_delayed])
                    2'b00: pht[train_index_delayed] <= train_taken_delayed ? 2'b01 : 2'b00;
                    2'b01: pht[train_index_delayed] <= train_taken_delayed ? 2'b10 : 2'b00;
                    2'b10: pht[train_index_delayed] <= train_taken_delayed ? 2'b11 : 2'b01;
                    2'b11: pht[train_index_delayed] <= train_taken_delayed ? 2'b11 : 2'b10;
                endcase
            end
        end
    end
    
    // History update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            committed_ghr <= 7'b0;
            speculative_ghr <= 7'b0;
            predict_index_reg <= 7'b0;
        end else begin
            // Precompute next prediction index
            predict_index_reg <= next_predict_index;
            
            // Update speculative history
            if (predict_valid)
                speculative_ghr <= {speculative_ghr[5:0], predict_taken};
            
            // Handle mispredictions (highest priority)
            if (train_valid && train_mispredicted) begin
                committed_ghr <= {train_history[5:0], train_taken};
                speculative_ghr <= {train_history[5:0], train_taken};
            end
            // Normal training updates committed history
            else if (train_valid) begin
                committed_ghr <= {committed_ghr[5:0], train_taken};
            end
        end
    end

endmodule