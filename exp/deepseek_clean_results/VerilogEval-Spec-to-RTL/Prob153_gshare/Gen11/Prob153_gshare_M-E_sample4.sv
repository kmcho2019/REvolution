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
    reg [6:0] confirmed_ghr;  // Updated only by training
    reg [6:0] speculative_ghr; // Updated by predictions
    
    // PHT (128 entries of 2-bit counters)
    reg [1:0] pht [0:127];
    
    // Misprediction pattern buffer (4 recent patterns)
    reg [3:0] mispred_buffer;
    
    // Prediction logic
    wire [6:0] predict_index = predict_pc ^ speculative_ghr;
    wire [6:0] mispred_index = predict_pc ^ mispred_buffer;
    wire main_prediction = pht[predict_index][1];
    wire mispred_hint = |mispred_buffer && pht[mispred_index][1];
    
    assign predict_taken = predict_valid ? (mispred_hint ? ~main_prediction : main_prediction) : 1'b0;
    assign predict_history = speculative_ghr;
    
    // Training index
    wire [6:0] train_index = train_pc ^ train_history;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            confirmed_ghr <= 7'b0;
            speculative_ghr <= 7'b0;
            mispred_buffer <= 4'b0;
            for (integer i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;  // Weakly not-taken
        end else begin
            // Update misprediction buffer
            if (train_valid && train_mispredicted)
                mispred_buffer <= {mispred_buffer[2:0], 1'b1};
            else if (train_valid && !train_mispredicted && |mispred_buffer)
                mispred_buffer <= {mispred_buffer[2:0], 1'b0};
            
            // PHT update - two phases
            if (predict_valid) begin
                // Early training based on prediction
                case (pht[predict_index])
                    2'b00: pht[predict_index] <= predict_taken ? 2'b01 : 2'b00;
                    2'b01: pht[predict_index] <= predict_taken ? 2'b10 : 2'b00;
                    2'b10: pht[predict_index] <= predict_taken ? 2'b11 : 2'b01;
                    2'b11: pht[predict_index] <= predict_taken ? 2'b11 : 2'b10;
                endcase
            end
            
            if (train_valid) begin
                // Final training based on actual outcome
                case (pht[train_index])
                    2'b00: pht[train_index] <= train_taken ? 2'b01 : 2'b00;
                    2'b01: pht[train_index] <= train_taken ? 2'b10 : 2'b00;
                    2'b10: pht[train_index] <= train_taken ? 2'b11 : 2'b01;
                    2'b11: pht[train_index] <= train_taken ? 2'b11 : 2'b10;
                endcase
            end
            
            // History update - training has priority
            if (train_valid) begin
                confirmed_ghr <= {train_history[5:0], train_taken};
                speculative_ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid) begin
                speculative_ghr <= {speculative_ghr[5:0], predict_taken};
            end
        end
    end

endmodule