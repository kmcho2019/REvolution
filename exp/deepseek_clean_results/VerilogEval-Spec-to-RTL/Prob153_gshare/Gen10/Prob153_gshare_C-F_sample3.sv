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
    // 128-entry pattern history table (2-bit saturating counters)
    reg [1:0] pht [0:127];

    // Prediction is combinational
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];  // MSB determines prediction
    assign predict_history = ghr;

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // PHT update (using arithmetic from Example 1)
            if (train_valid) begin
                if (train_taken) begin
                    pht[train_index] <= (pht[train_index] == 2'b11) ? 2'b11 : pht[train_index] + 1;
                end else begin
                    pht[train_index] <= (pht[train_index] == 2'b00) ? 2'b00 : pht[train_index] - 1;
                end
            end
            
            // GHR update (clear priority structure from Example 2)
            if (train_valid && train_mispredicted) begin
                // Training with misprediction has highest priority
                ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid) begin
                // Prediction update when no training misprediction
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule