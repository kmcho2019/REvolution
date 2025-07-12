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

    reg [6:0] ghr;
    reg [1:0] pht [0:127];
    reg [1:0] next_pht [0:127];
    reg pht_update_en;
    reg [6:0] pht_update_idx;
    reg [1:0] pht_update_val;
    
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];
    assign predict_history = ghr;

    // PHT update handling
    always @(*) begin
        if (train_valid) begin
            pht_update_en = 1'b1;
            pht_update_idx = train_pc ^ train_history;
            if (train_taken) begin
                pht_update_val = (pht[pht_update_idx] == 2'b11) ? 
                                2'b11 : pht[pht_update_idx] + 1;
            end else begin
                pht_update_val = (pht[pht_update_idx] == 2'b00) ? 
                                2'b00 : pht[pht_update_idx] - 1;
            end
        end else begin
            pht_update_en = 1'b0;
            pht_update_idx = 7'b0;
            pht_update_val = 2'b0;
        end
    end

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
        end else begin
            // Apply PHT updates from training
            if (pht_update_en) begin
                pht[pht_update_idx] <= pht_update_val;
            end

            // GHR updates - training has absolute priority
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end else if (train_valid) begin
                // Training without misprediction - no GHR update
                ghr <= ghr;
            end else if (predict_valid) begin
                // Only update GHR if no training in this cycle
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule