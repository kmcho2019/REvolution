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

wire [6:0] predict_index;
wire [6:0] train_index;

assign predict_index = {predict_pc[6:1], predict_pc[0] ^ history[0]};
assign train_index = {train_pc[6:1], train_pc[0] ^ train_history[0]};

always @(posedge clk or posedge areset) begin
    if (areset) begin
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else begin
        if (train_valid && train_mispredicted) begin
            history <= train_history;
        end else if (predict_valid) begin
            if (pht[predict_index] >= 2'b10) begin
                history <= {history[5:0], 1'b1};
            end else begin
                history <= {history[5:0], 1'b0};
            end
        end
    end
end

always @(posedge clk) begin
    if (train_valid) begin
        if (train_taken) begin
            if (pht[train_index]!= 2'b11) begin
                pht[train_index] <= pht[train_index] + 1;
            end
        end else begin
            if (pht[train_index]!= 2'b00) begin
                pht[train_index] <= pht[train_index] - 1;
            end
        end
    end
end

always @(posedge clk) begin
    if (predict_valid) begin
        if (pht[predict_index] >= 2'b10) begin
            predict_taken <= 1'b1;
        end else begin
            predict_taken <= 1'b0;
        end
        predict_history <= history;
    end
end

endmodule