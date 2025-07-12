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

reg [1:0] gshare_pht [127:0];
reg [6:0] history;

wire [6:0] gshare_index = predict_pc ^ history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        for (int i = 0; i < 128; i++) begin
            gshare_pht[i] <= 2'b0;
        end
        history <= 7'b0;
    end else if (train_valid) begin
        if (train_mispredicted) begin
            history <= train_history;
        end else begin
            history <= {history[5:0], train_taken};
        end
        
        if (train_taken) begin
            if (gshare_pht[train_pc] < 2'b11) begin
                gshare_pht[train_pc] <= gshare_pht[train_pc] + 1;
            end
        end else begin
            if (gshare_pht[train_pc] > 2'b00) begin
                gshare_pht[train_pc] <= gshare_pht[train_pc] - 1;
            end
        end
    end else if (predict_valid) begin
        history <= {history[5:0], (gshare_pht[gshare_index] >= 2'b10)};
    end
end

always @(posedge clk) begin
    if (predict_valid) begin
        predict_taken <= (gshare_pht[gshare_index] >= 2'b10);
        predict_history <= history;
    end
end

endmodule