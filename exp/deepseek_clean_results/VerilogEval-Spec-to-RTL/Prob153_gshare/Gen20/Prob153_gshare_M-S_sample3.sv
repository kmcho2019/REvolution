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

    // 7-bit global history register
    reg [6:0] ghr;
    // Pattern history table (128 entries of 2-bit counters)
    reg [1:0] pht [0:127];

    // Prediction index and output
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];
    assign predict_history = ghr;

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;

    // Sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;  // Weakly not-taken
        end else begin
            // Handle training first (higher priority)
            if (train_valid) begin
                // Update PHT if not at saturation
                if ((train_taken && pht[train_index] != 2'b11) || 
                    (!train_taken && pht[train_index] != 2'b00)) begin
                    pht[train_index] <= train_taken ? pht[train_index] + 1 : pht[train_index] - 1;
                end

                // Update GHR if mispredicted
                if (train_mispredicted)
                    ghr <= {train_history[5:0], train_taken};
            end 
            // Then handle prediction if no training
            else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule