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
    end else if (predict_valid) begin
        gbhr <= {gbhr[5:0], predict_taken};
    end else if (train_valid && train_mispredicted) begin
        gbhr <= train_history;
    end
end

// PHT table
reg [1:0] pht [127:0];
always @(posedge clk or posedge areset) begin
    if (areset) begin
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01; // initialize to weakly taken
        end
    end else if (train_valid) begin
        pht[{train_pc[6:1], train_history[0]}] <= train_taken? (pht[{train_pc[6:1], train_history[0]}] == 2'b11? 2'b11 : pht[{train_pc[6:1], train_history[0]}] + 1'b1) : (pht[{train_pc[6:1], train_history[0]}] == 2'b00? 2'b00 : pht[{train_pc[6:1], train_history[0]}] - 1'b1);
    end
end

// prediction logic
always @(posedge clk) begin
    if (predict_valid) begin
        predict_taken <= pht[{predict_pc[6:1], gbhr[0]}][1];
        predict_history <= gbhr;
    end
end

endmodule