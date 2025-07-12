module TopModule(
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
reg [1:0] pht [127:0];

integer i;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        ghr <= 7'b0;
        for (i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else begin
        reg [6:0] ghr_next;
        ghr_next = ghr;
        
        if (train_valid) begin
            if (train_mispredicted) begin
                ghr_next = train_history;
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
            reg [6:0] index;
            index = (predict_pc ^ ghr)[6:0];
            ghr_next = {ghr[5:0], pht[index][1]};
        end
        
        ghr <= ghr_next;
        
        // Corrected continuous assignments
        if (predict_valid) begin
            predict_taken <= pht[(predict_pc ^ ghr)[6:0]][1];
            predict_history <= ghr;
        end
    end
end

endmodule