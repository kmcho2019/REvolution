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
reg [127:0] [1:0] pht;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        ghr <= 7'b0;
        pht <= {128{2'b01}};
    end else begin
        if (train_valid) begin
            if (train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid) begin
                // Update GHR based on prediction for next cycle
                ghr <= {ghr[5:0], pht[(predict_pc ^ ghr)[6:0]][1]};
            end
            
            reg [6:0] index;
            index = (train_pc ^ train_history)[6:0];
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
            // Only update GHR if not training
            ghr <= {ghr[5:0], pht[(predict_pc ^ ghr)[6:0]][1]};
        end
    end
end

assign predict_taken = pht[(predict_pc ^ ghr)[6:0]][1];
assign predict_history = ghr;

endmodule