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

// Combinational logic to calculate the index
assign predict_history = ghr;
assign predict_taken = pht[(predict_pc ^ ghr)[6:0]][1];

// Sequential logic for GHR and PHT updates
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        ghr <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else begin
        if (train_valid) begin
            if (train_mispredicted) begin
                ghr <= train_history;
            end else begin
                // Update GHR for correct prediction
                reg [6:0] index;
                index = (train_pc ^ train_history)[6:0];
                if (train_taken) begin
                    if (pht[index]!= 2'b11) begin
                        pht[index] <= pht[index] + 1'b1;
                    end
                end else begin
                    if (pht[index]!= 2'b00) begin
                        pht[index] <= pht[index] - 1'b1;
                    end
                end
            end
        end else if (predict_valid) begin
            // Update GHR for prediction
            reg [6:0] index;
            index = (predict_pc ^ ghr)[6:0];
            ghr <= {ghr[5:0], pht[index][1]};
        end
    end
end

endmodule