module TopModule(
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output reg predict_taken,
    output reg [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

// PHT table
reg [1:0] pht [127:0];
reg [6:0] gbhr;
reg [6:0] index;

// Initialize PHT table and GBHR
always @(posedge clk or posedge areset) begin
    if (areset) begin
        gbhr <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01; // initialize to weakly taken
        end
    end else begin
        // Update GBHR and PHT table
        if (train_valid) begin
            if (train_mispredicted) begin
                gbhr <= train_history;
            end
            index = {train_pc[6:1] ^ train_history[5:0]};
            if (train_taken) begin
                pht[index] <= (pht[index] == 2'b11) ? 2'b11 : pht[index] + 1'b1;
            end else begin
                pht[index] <= (pht[index] == 2'b00) ? 2'b00 : pht[index] - 1'b1;
            end
        end else if (predict_valid) begin
            gbhr <= {gbhr[5:0], predict_taken};
        end
    end
end

// Prediction logic
always @(*) begin
    index = {predict_pc[6:1] ^ gbhr[5:0]};
    predict_taken = (pht[index] >= 2'b10);
    predict_history = gbhr;
end

endmodule