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
reg [6:0] pht_index;
reg [1:0] pht_value;
reg [1:0] next_pht_value;
reg predict_taken_reg;
reg [6:0] predict_history_reg;

reg [7:0] pht [127:0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else begin
        if (train_valid) begin
            pht_index <= train_pc ^ train_history;
            if (train_mispredicted) begin
                global_history <= train_history;
            end
            if (train_taken) begin
                if (pht[pht_index] < 2'b11) begin
                    pht[pht_index] <= pht[pht_index] + 1'b1;
                end
            end else begin
                if (pht[pht_index] > 2'b00) begin
                    pht[pht_index] <= pht[pht_index] - 1'b1;
                end
            end
        end

        if (predict_valid) begin
            pht_index <= predict_pc ^ global_history;
            predict_taken_reg <= (pht[pht_index] > 2'b01);
            predict_history_reg <= global_history;
            if (predict_taken_reg) begin
                global_history <= {global_history[5:0], 1'b1};
            end else begin
                global_history <= {global_history[5:0], 1'b0};
            end
        end
    end
end

assign predict_taken = predict_taken_reg;
assign predict_history = predict_history_reg;

endmodule