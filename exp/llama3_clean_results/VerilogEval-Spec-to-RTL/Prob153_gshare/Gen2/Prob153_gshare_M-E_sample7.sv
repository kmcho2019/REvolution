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
reg [1:0] pht [127:0];
reg [1:0] pht_next [127:0];

always @(*) begin
    ghr_next = ghr;
    if (train_valid) begin
        if (train_mispredicted) begin
            ghr_next = train_history;
        end else if (predict_valid) begin
            ghr_next = {ghr[5:0], predict_taken};
        end
    end else if (predict_valid) begin
        ghr_next = {ghr[5:0], predict_taken};
    end
end

always @(*) begin
    pht_next = pht;
    if (train_valid) begin
        reg [6:0] index;
        index = (train_pc ^ train_history)[6:0];
        if (train_taken) begin
            if (pht[index] != 2'b11) begin
                pht_next[index] = pht[index] + 1;
            end
        end else begin
            if (pht[index] != 2'b00) begin
                pht_next[index] = pht[index] - 1;
            end
        end
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        ghr <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else begin
        ghr <= ghr_next;
        pht <= pht_next;
    end
end

always @(*) begin
    reg [6:0] index;
    index = (predict_pc ^ ghr)[6:0];
    if (pht[index] == 2'b11) begin
        predict_taken = 1'b1;
    end else if (pht[index] == 2'b00) begin
        predict_taken = 1'b0;
    end else begin
        // Fallback to always taken or always not taken
        predict_taken = 1'b1; // Always taken
    end
    predict_history = ghr;
end

endmodule