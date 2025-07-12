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

reg [6:0] ghr;
reg [6:0] predict_ghr;
reg predict_taken_reg;
reg [127:0][1:0] pht;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        ghr <= 7'b0;
        pht <= '{default: 2'b0};
    end else begin
        if (train_valid) begin
            // Update PHT entry
            pht[{train_pc[6:0], train_history[6:0]}] <= (train_taken) ? (pht[{train_pc[6:0], train_history[6:0]}] == 2'b11) ? 2'b11 : pht[{train_pc[6:0], train_history[6:0]}] + 1'b1 : (pht[{train_pc[6:0], train_history[6:0]}] == 2'b00) ? 2'b00 : pht[{train_pc[6:0], train_history[6:0]}] - 1'b1;

            // Recover GHR if mispredicted
            if (train_mispredicted) begin
                ghr <= train_history;
            end
        end

        if (predict_valid) begin
            // Update GHR
            ghr <= {ghr[5:0], predict_taken_reg};
        end
    end
end

always @(*) begin
    // Predict branch direction
    predict_taken_reg = (pht[{predict_pc[6:0], ghr[6:0]}] >= 2'b10);
    predict_history = ghr;
    predict_taken = predict_taken_reg;
end

endmodule