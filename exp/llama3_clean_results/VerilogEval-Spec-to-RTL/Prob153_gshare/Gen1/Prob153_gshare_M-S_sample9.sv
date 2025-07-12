module TopModule (
    input  clk,
    input  areset,

    input  predict_valid,
    input  [6:0] predict_pc,
    output reg predict_taken,
    output reg [6:0] predict_history,

    input  train_valid,
    input  train_taken,
    input  train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);

reg [6:0] ghr;
reg [127:0] [1:0] pht;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        ghr <= 0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 0;
        end
    end else begin
        if (train_mispredicted && train_valid) begin
            ghr <= train_history;
        end else if (predict_valid) begin
            ghr <= {ghr[5:0], predict_taken};
        end

        if (train_valid) begin
            reg [6:0] index;
            index = train_pc ^ train_history;
            if (train_taken) begin
                pht[index] <= (pht[index] == 3)? 3 : pht[index] + 1;
            end else begin
                pht[index] <= (pht[index] == 0)? 0 : pht[index] - 1;
            end
        end
    end
end

always @(*) begin
    if (predict_valid) begin
        reg [6:0] index;
        index = predict_pc ^ ghr;
        predict_taken = (pht[index] >= 2)? 1 : 0;
        predict_history = ghr;
    end else begin
        predict_taken = 0;
        predict_history = 0;
    end
end

endmodule