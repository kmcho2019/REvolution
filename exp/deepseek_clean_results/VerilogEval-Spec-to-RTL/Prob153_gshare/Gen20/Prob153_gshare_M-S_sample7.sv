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

    // Index calculation (shared for both prediction and training)
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Prediction is combinational
    assign predict_taken = pht[predict_index][1];
    assign predict_history = ghr;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;  // Weakly not-taken
        end else begin
            // Training has priority
            if (train_valid) begin
                // Arithmetic PHT update (simpler than case statement)
                if (train_taken && pht[train_index] != 2'b11)
                    pht[train_index] <= pht[train_index] + 1;
                else if (!train_taken && pht[train_index] != 2'b00)
                    pht[train_index] <= pht[train_index] - 1;

                // GHR update for misprediction
                if (train_mispredicted)
                    ghr <= {train_history[5:0], train_taken};
            end 
            // Prediction update if no training or no misprediction
            else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule