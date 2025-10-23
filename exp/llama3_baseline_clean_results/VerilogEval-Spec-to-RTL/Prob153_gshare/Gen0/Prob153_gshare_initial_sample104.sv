module TopModule(
    input  clk,
    input  areset,

    input  predict_valid,
    input  [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input  train_valid,
    input  train_taken,
    input  train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);

reg [6:0] ghr;
reg [1:0] pht [127:0];

assign predict_taken = (pht[{predict_pc[6:1], ghr[6:1]}] >= 2'b02);
assign predict_history = ghr;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        ghr <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else begin
        if (train_valid) begin
            if (train_mispredicted) begin
                ghr <= train_history;
            end else if (train_taken) begin
                ghr <= {ghr[5:0], 1'b1};
            end else begin
                ghr <= {ghr[5:0], 1'b0};
            end

            if (train_taken) begin
                if (pht[{train_pc[6:1], train_history[6:1]}] != 2'b11) begin
                    pht[{train_pc[6:1], train_history[6:1]}] <= pht[{train_pc[6:1], train_history[6:1]}] + 2'b01;
                end
            end else begin
                if (pht[{train_pc[6:1], train_history[6:1]}] != 2'b00) begin
                    pht[{train_pc[6:1], train_history[6:1]}] <= pht[{train_pc[6:1], train_history[6:1]}] - 2'b01;
                end
            end
        end else if (predict_valid) begin
            if (predict_taken) begin
                ghr <= {ghr[5:0], 1'b1};
            end else begin
                ghr <= {ghr[5:0], 1'b0};
            end
        end
    end
end

endmodule