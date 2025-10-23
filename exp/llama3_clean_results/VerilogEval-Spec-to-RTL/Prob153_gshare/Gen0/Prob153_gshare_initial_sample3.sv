module TopModule (
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
reg [6:0] ghr_next;
reg [127:0] [1:0] pht;
reg [1:0] pht_next;

integer i;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        ghr <= 0;
        for (i = 0; i < 128; i++) begin
            pht[i] <= 0;
        end
    end else begin
        ghr <= ghr_next;
        for (i = 0; i < 128; i++) begin
            pht[i] <= pht_next[i];
        end
    end
end

always @(*) begin
    ghr_next = ghr;
    for (i = 0; i < 128; i++) begin
        pht_next[i] = pht[i];
    end

    if (train_valid) begin
        reg [6:0] index;
        index = (train_pc ^ train_history);
        if (train_taken) begin
            if (pht[index] < 3) begin
                pht_next[index] = pht[index] + 1;
            end
        end else begin
            if (pht[index] > 0) begin
                pht_next[index] = pht[index] - 1;
            end
        end
        if (train_mispredicted) begin
            ghr_next = train_history;
        end
    end

    if (predict_valid && !train_valid || predict_valid && train_mispredicted) begin
        reg [6:0] index;
        index = (predict_pc ^ ghr);
        if (pht[index] >= 2) begin
            predict_taken = 1;
        end else begin
            predict_taken = 0;
        end
        predict_history = ghr;
        if (predict_taken) begin
            ghr_next = {ghr[5:0], 1};
        end else begin
            ghr_next = {ghr[5:0], 0};
        end
    end
end

endmodule