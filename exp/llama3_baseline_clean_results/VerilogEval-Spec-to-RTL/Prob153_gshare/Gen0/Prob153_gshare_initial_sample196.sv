module TopModule(
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

reg [6:0] global_history;
reg [6:0] predict_history_reg;
reg predict_taken_reg;

reg [7:0] pht_index;
reg [1:0] pht_value;

reg [127:0][1:0] pht;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 0;
        predict_history_reg <= 0;
        predict_taken_reg <= 0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b00;
        end
    end else if (train_valid) begin
        pht_index <= (train_pc ^ train_history);
        pht[pht_index] <= (train_mispredicted && train_taken) ? (pht[pht_index] + 1'b1) :
                          (train_mispredicted && !train_taken) ? (pht[pht_index] - 1'b1) :
                          pht[pht_index];
        if (train_mispredicted) begin
            global_history <= train_history;
        end
    end else if (predict_valid) begin
        pht_index <= (predict_pc ^ global_history);
        predict_taken_reg <= (pht[pht_index] >= 2'b01);
        predict_history_reg <= global_history;
        global_history <= (predict_taken_reg) ? (global_history << 1) | 1'b1 :
                          (global_history << 1);
    end
end

assign predict_taken = predict_taken_reg;
assign predict_history = predict_history_reg;

always @(*) begin
    predict_taken_reg = (pht[pht_index] >= 2'b01);
    predict_history_reg = global_history;
end

endmodule