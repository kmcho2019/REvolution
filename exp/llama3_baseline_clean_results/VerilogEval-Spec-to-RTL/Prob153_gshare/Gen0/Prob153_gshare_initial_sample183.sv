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
reg [6:0] ghr_next;
reg [6:0] index;
reg [1:0] pht_value;
reg [1:0] pht_value_next;
reg [6:0] pht [127:0];

always @(*) begin
    ghr_next = ghr;
    pht_value_next = pht_value;
    index = ghr ^ predict_pc;
    pht_value = pht[index];

    predict_taken = (pht_value == 2'b11 || pht_value == 2'b10);
    predict_history = ghr;

    if (train_valid) begin
        pht_value_next = pht[train_history ^ train_pc];
        if (train_mispredicted) begin
            ghr_next = train_history;
        end
        if (train_taken) begin
            if (pht_value_next != 2'b11) begin
                pht_value_next = pht_value_next + 1;
            end
        end else begin
            if (pht_value_next != 2'b00) begin
                pht_value_next = pht_value_next - 1;
            end
        end
    end

    if (predict_valid && !train_valid) begin
        ghr_next = {ghr[5:0], predict_taken};
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        ghr <= 7'd0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'd0;
        end
    end else begin
        ghr <= ghr_next;
        pht[index] <= pht_value_next;
        if (train_valid) begin
            pht[train_history ^ train_pc] <= pht_value_next;
        end
    end
end

endmodule