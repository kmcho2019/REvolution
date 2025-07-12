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

// Local level
reg [3:0] local_ghr;
reg [1:0] local_pht [15:0];

// Global level
reg [6:0] global_ghr;
reg [1:0] global_pht [127:0];

// Confidence signal
reg confidence;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        local_ghr <= 4'b0;
        global_ghr <= 7'b0;
    end else begin
        if (train_valid) begin
            if (train_mispredicted) begin
                local_ghr <= train_history[3:0];
                global_ghr <= train_history;
            end
            if (predict_valid) begin
                local_ghr <= {local_ghr[2:0], local_pht[(predict_pc[3:0] ^ local_ghr)[3:0]][1]};
                global_ghr <= {global_ghr[5:0], global_pht[(predict_pc ^ global_ghr)[6:0]][1]};
            end
        end else if (predict_valid) begin
            local_ghr <= {local_ghr[2:0], local_pht[(predict_pc[3:0] ^ local_ghr)[3:0]][1]};
            global_ghr <= {global_ghr[5:0], global_pht[(predict_pc ^ global_ghr)[6:0]][1]};
        end
    end
end

always @(posedge clk) begin
    if (train_valid) begin
        if (train_taken) begin
            if (local_pht[(predict_pc[3:0] ^ local_ghr)[3:0]] != 2'b11) begin
                local_pht[(predict_pc[3:0] ^ local_ghr)[3:0]] <= local_pht[(predict_pc[3:0] ^ local_ghr)[3:0]] + 1'b1;
            end
            if (global_pht[(predict_pc ^ global_ghr)[6:0]] != 2'b11) begin
                global_pht[(predict_pc ^ global_ghr)[6:0]] <= global_pht[(predict_pc ^ global_ghr)[6:0]] + 1'b1;
            end
        end else begin
            if (local_pht[(predict_pc[3:0] ^ local_ghr)[3:0]] != 2'b00) begin
                local_pht[(predict_pc[3:0] ^ local_ghr)[3:0]] <= local_pht[(predict_pc[3:0] ^ local_ghr)[3:0]] - 1'b1;
            end
            if (global_pht[(predict_pc ^ global_ghr)[6:0]] != 2'b00) begin
                global_pht[(predict_pc ^ global_ghr)[6:0]] <= global_pht[(predict_pc ^ global_ghr)[6:0]] - 1'b1;
            end
        end
    end
end

assign predict_taken = (local_pht[(predict_pc[3:0] ^ local_ghr)[3:0]][1] == 1'b1) ? 1'b1 : global_pht[(predict_pc ^ global_ghr)[6:0]][1];
assign predict_history = global_ghr;
assign confidence = (local_pht[(predict_pc[3:0] ^ local_ghr)[3:0]] == 2'b11) ? 1'b1 : (global_pht[(predict_pc ^ global_ghr)[6:0]] == 2'b11) ? 1'b1 : 1'b0;

endmodule