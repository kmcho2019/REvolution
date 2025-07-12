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

reg [6:0] global_history;
reg [1:0] pht [127:0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else begin
        if (train_valid && train_mispredicted) begin
            global_history <= train_history;
        end else if (predict_valid) begin
            global_history <= {global_history[5:0], (pht[predict_pc ^ global_history] >= 2'b10)? 1'b1 : 1'b0};
        end
    end
end

always @(posedge clk) begin
    if (predict_valid) begin
        predict_taken <= (pht[predict_pc ^ global_history] >= 2'b10);
        predict_history <= global_history;
    end
end

always @(posedge clk) begin
    if (train_valid) begin
        if (train_taken) begin
            if (pht[train_pc ^ train_history]!= 2'b11) begin
                pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] + 1'b1;
            end
        end else begin
            if (pht[train_pc ^ train_history]!= 2'b00) begin
                pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] - 1'b1;
            end
        end
    end
end

endmodule