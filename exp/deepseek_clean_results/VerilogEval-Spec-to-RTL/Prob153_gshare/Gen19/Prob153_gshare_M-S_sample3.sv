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

    // Global History Register
    reg [6:0] ghr;
    // Pattern History Table (128 entries of 2-bit counters)
    reg [1:0] pht [0:127];

    // Prediction index and output
    wire [6:0] predict_idx = predict_pc ^ ghr;
    assign predict_taken = pht[predict_idx][1];
    assign predict_history = ghr;

    // Training index
    wire [6:0] train_idx = train_pc ^ train_history;

    // PHT update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize all PHT entries to weakly not-taken
            for (integer i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
        end
        else if (train_valid) begin
            // Simplified PHT update with bounds checking
            if (train_taken && pht[train_idx] != 2'b11)
                pht[train_idx] <= pht[train_idx] + 1;
            else if (!train_taken && pht[train_idx] != 2'b00)
                pht[train_idx] <= pht[train_idx] - 1;
        end
    end

    // GHR update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
        end
        else if (train_valid && train_mispredicted) begin
            ghr <= {train_history[5:0], train_taken};
        end
        else if (predict_valid) begin
            ghr <= {ghr[5:0], predict_taken};
        end
    end

endmodule