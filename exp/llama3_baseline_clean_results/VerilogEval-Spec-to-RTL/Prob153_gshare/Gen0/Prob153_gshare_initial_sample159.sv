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
reg [127:0][1:0] pht;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        ghr <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else if (train_valid) begin
        if (train_mispredicted) begin
            ghr <= train_history;
        end else begin
            ghr <= {ghr[5:0], train_taken};
        end
        if (pht[{train_pc[6:2], ghr[6:3]}] == 2'b00 && train_taken) begin
            pht[{train_pc[6:2], ghr[6:3]}] <= 2'b01;
        end else if (pht[{train_pc[6:2], ghr[6:3]}] == 2'b11 && !train_taken) begin
            pht[{train_pc[6:2], ghr[6:3]}] <= 2'b10;
        end else if (train_taken) begin
            pht[{train_pc[6:2], ghr[6:3]}] <= pht[{train_pc[6:2], ghr[6:3]}] + 1'b1;
        end else begin
            pht[{train_pc[6:2], ghr[6:3]}] <= pht[{train_pc[6:2], ghr[6:3]}] - 1'b1;
        end
    end else if (predict_valid) begin
        ghr <= {ghr[5:0], 1'b1}; // assuming the predicted branch is taken
    end
end

always @(*) begin
    predict_history = ghr;
    predict_taken = (pht[{predict_pc[6:2], ghr[6:3]}] >= 2'b10);
end

endmodule