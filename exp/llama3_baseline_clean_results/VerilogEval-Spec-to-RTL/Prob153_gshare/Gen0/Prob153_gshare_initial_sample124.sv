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

// Global Branch History Register
reg [6:0] ghr;

// Pattern History Table
reg [1:0] pht [127:0];

// Index calculation for PHT
wire [6:0] pht_index;
assign pht_index = predict_pc ^ ghr;

// Predicted branch direction
assign predict_taken = (pht[pht_index] == 2'b11) || (pht[pht_index] == 2'b10);

// Update ghr and PHT on positive clock edge
always @(posedge clk or posedge areset) begin
    if (areset) begin
        ghr <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else begin
        if (train_valid && train_mispredicted) begin
            ghr <= train_history;
        end else if (predict_valid) begin
            ghr <= {ghr[5:0], predict_taken};
        end

        if (train_valid) begin
            if (train_taken) begin
                if (pht[train_pc ^ train_history] != 2'b11) begin
                    pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] + 1;
                end
            end else begin
                if (pht[train_pc ^ train_history] != 2'b00) begin
                    pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] - 1;
                end
            end
        end
    end
end

assign predict_history = ghr;

endmodule