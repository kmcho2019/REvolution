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
reg [6:0] gshare_index;
reg [6:0] history;

assign gshare_index = predict_pc ^ history;

always @(posedge clk or negedge areset) begin
    if (~areset) begin
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            gshare_pht[i] <= 2'b0;
        end
    end else begin
        // Prediction logic
        if (predict_valid) begin
            predict_taken <= (gshare_pht[gshare_index] >= 2'b10);
            predict_history <= history;
            history <= {history[5:0], (gshare_pht[gshare_index] >= 2'b10)};
        end

        // Training logic
        if (train_valid) begin
            if (train_taken) begin
                gshare_pht[train_pc ^ train_history] <= (gshare_pht[train_pc ^ train_history] == 2'b11)? 2'b11 : gshare_pht[train_pc ^ train_history] + 1;
            end else begin
                gshare_pht[train_pc ^ train_history] <= (gshare_pht[train_pc ^ train_history] == 2'b00)? 2'b00 : gshare_pht[train_pc ^ train_history] - 1;
            end
            if (train_mispredicted) begin
                history <= train_history;
            end
        end
    end
end

endmodule