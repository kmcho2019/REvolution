module TopModule(
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output reg predict_taken,
    output reg [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

reg [1:0] pht [127:0];
reg [6:0] global_history;
reg [6:0] mispredict_history;
reg [6:0] mispredict_pc;
reg mispredict_valid;

wire [6:0] index;
assign index = predict_pc ^ global_history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        mispredict_history <= 7'b0;
        mispredict_pc <= 7'b0;
        mispredict_valid <= 1'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b00;
        end
    end else if (predict_valid) begin
        if (pht[index] >= 2'b10) begin
            global_history <= {global_history[5:0], 1'b1};
        end else begin
            global_history <= {global_history[5:0], 1'b0};
        end
    end else if (train_valid && train_mispredicted) begin
        mispredict_history <= global_history;
        mispredict_pc <= train_pc;
        mispredict_valid <= 1'b1;
    end else if (train_valid && !train_mispredicted && mispredict_valid) begin
        global_history <= mispredict_history;
        mispredict_valid <= 1'b0;
    end
end

always @(posedge clk) begin
    if (predict_valid) begin
        predict_taken <= (pht[index] >= 2'b10);
        predict_history <= global_history;
    end
end

always @(posedge clk) begin
    if (train_valid) begin
        if (train_taken) begin
            if (pht[train_pc ^ train_history] != 2'b11) begin
                pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] + 1'b1;
            end
        end else begin
            if (pht[train_pc ^ train_history] != 2'b00) begin
                pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] - 1'b1;
            end
        end
    end
end

endmodule