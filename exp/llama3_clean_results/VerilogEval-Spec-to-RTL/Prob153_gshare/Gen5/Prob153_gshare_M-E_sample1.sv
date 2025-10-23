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
    end else if (train_valid) begin
        if (train_mispredicted) begin
            ghr <= train_history;
        end else if (predict_valid) begin
            ghr <= {ghr[5:0], pht[index][1]};
        end
    end else if (predict_valid) begin
        ghr <= {ghr[5:0], pht[index][1]};
    end
end

always @(posedge clk) begin
    if (train_valid) begin
        index <= predict_pc ^ ghr;
        pht_value <= pht[index];
        
        if (train_taken) begin
            if (pht_value!= 2'b11) begin
                pht[index] <= pht_value + 1'b1;
            end
        end else begin
            if (pht_value!= 2'b00) begin
                pht[index] <= pht_value - 1'b1;
            end
        end
    end
end

assign predict_taken = (pht[index][1] == 1'b1)? 1'b1 : 1'b0;
assign predict_history = ghr;

endmodule