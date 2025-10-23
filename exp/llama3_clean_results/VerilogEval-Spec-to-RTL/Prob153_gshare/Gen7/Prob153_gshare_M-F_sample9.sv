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

reg [6:0] index;
reg [1:0] pht_value;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        ghr <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01; // initialize pht to weakly taken
        end
    end else if (train_valid) begin
        if (train_mispredicted) begin
            ghr <= train_history;
        end else begin
            ghr <= {ghr[5:0], train_taken};
        end
    end else if (predict_valid && !train_valid) begin
        ghr <= {ghr[5:0], pht[predict_pc ^ ghr][1]};
    end
end

always @(posedge clk) begin
    if (train_valid) begin
        index <= train_pc ^ train_history;
        if (train_taken) begin
            if (pht[index] != 2'b11) begin
                pht[index] <= pht[index] + 1'b1;
            end
        end else begin
            if (pht[index] != 2'b00) begin
                pht[index] <= pht[index] - 1'b1;
            end
        end
    end else if (predict_valid) begin
        index <= predict_pc ^ ghr;
        pht_value <= pht[index];
    end
end

assign predict_taken = (pht_value == 2'b11 || pht_value == 2'b10) ? 1'b1 : 1'b0;
assign predict_history = ghr;

endmodule