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
    
    // Shared XOR logic
    wire [6:0] xor_index = predict_valid ? (predict_pc ^ ghr) : (train_pc ^ train_history);
    
    // Prediction is combinational
    assign predict_taken = predict_valid ? pht[xor_index][1] : 1'b0;
    assign predict_history = ghr;

    // Clock gating for PHT
    wire pht_update = train_valid;
    wire pht_clk = pht_update ? clk : 1'b0;
    
    // Update PHT and GHR
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR
            ghr <= 7'b0;
        end else begin
            // GHR update - training has priority
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid && !(train_valid && train_mispredicted)) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

    // PHT update with simplified logic
    always @(posedge pht_clk or posedge areset) begin
        if (areset) begin
            // Reset PHT
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else if (train_valid) begin
            // Simplified saturating counter update
            if (train_taken && pht[xor_index] != 2'b11)
                pht[xor_index] <= pht[xor_index] + 1;
            else if (!train_taken && pht[xor_index] != 2'b00)
                pht[xor_index] <= pht[xor_index] - 1;
        end
    end

endmodule