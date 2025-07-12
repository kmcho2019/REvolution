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
reg [6:0] history;

assign predict_taken = (pht[predict_pc ^ history] >= 2'b10);
assign predict_history = history;

always @(posedge clk) begin
    if (areset) begin
        history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else begin
        if (train_valid) begin
            if (train_mispredicted) begin
                history <= train_history;
            end else if (train_taken) begin
                history <= {history[5:0], 1'b1};
            end else begin
                history <= {history[5:0], 1'b0};
            end
            if (train_taken) begin
                pht[train_pc ^ train_history] <= (pht[train_pc ^ train_history] == 2'b11)? 2'b11 : pht[train_pc ^ train_history] + 1;
            end else begin
                pht[train_pc ^ train_history] <= (pht[train_pc ^ train_history] == 2'b00)? 2'b00 : pht[train_pc ^ train_history] - 1;
            end
        end else if (predict_valid) begin
            if (predict_taken) begin
                history <= {history[5:0], 1'b1};
            end else begin
                history <= {history[5:0], 1'b0};
            end
        end
    end
end

endmodule