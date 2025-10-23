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
    // Pattern history table (128 entries of 2-bit saturating counters)
    reg [1:0] pht [0:127];

    // Prediction index and output
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];  // MSB determines prediction
    assign predict_history = ghr;

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;

    // Sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and initialize PHT to weakly taken
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
        end else begin
            // Update GHR - training misprediction has highest priority
            if (train_valid && train_mispredicted)
                ghr <= {train_history[5:0], train_taken};
            else if (predict_valid)
                ghr <= {ghr[5:0], predict_taken};

            // Update PHT if training
            if (train_valid) begin
                if (train_taken)
                    pht[train_index] <= (pht[train_index] == 2'b11) ? 2'b11 : pht[train_index] + 1;
                else
                    pht[train_index] <= (pht[train_index] == 2'b00) ? 2'b00 : pht[train_index] - 1;
            end
        end
    end

endmodule