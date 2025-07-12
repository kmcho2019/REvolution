module TopModule(
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

// GBHR register
reg [6:0] gbhr;
always @(posedge clk or posedge areset) begin
    if (areset) begin
        gbhr <= 7'b0;
    end else if (train_valid && train_mispredicted) begin
        gbhr <= train_history;
    end else if (predict_valid) begin
        gbhr <= {gbhr[5:0], predict_taken};
    end
end

// Saturating counters
reg [1:0] pht [127:0];
always @(posedge clk or posedge areset) begin
    if (areset) begin
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01; // initialize to weakly taken
        end
    end else if (train_valid) begin
        reg [6:0] index;
        index = {train_pc[6:1], gbhr[0]};
        if (train_taken) begin
            if (pht[index] != 2'b11) begin
                pht[index] <= pht[index] + 1'b1;
            end
        end else begin
            if (pht[index] != 2'b00) begin
                pht[index] <= pht[index] - 1'b1;
            end
        end
    end
end

// Prediction logic
reg [6:0] index;
assign index = {predict_pc[6:1], gbhr[0]};
assign predict_taken = (pht[index] == 2'b11 || pht[index] == 2'b10);
assign predict_history = gbhr;

endmodule