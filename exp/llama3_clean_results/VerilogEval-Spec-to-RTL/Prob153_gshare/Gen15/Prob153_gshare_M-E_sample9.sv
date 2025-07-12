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
reg [6:0] predicted_history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        history <= 7'b0;
        predicted_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else begin
        // Prediction logic
        if (predict_valid) begin
            predict_taken <= (pht[predict_pc ^ history] >= 2'b10);
            predict_history <= history;
            predicted_history <= {history[5:0], (pht[predict_pc ^ history] >= 2'b10)};
        end

        // Training logic
        if (train_valid) begin
            if (train_taken) begin
                pht[train_pc ^ train_history] <= (pht[train_pc ^ train_history] == 2'b11)? 2'b11 : pht[train_pc ^ train_history] + 1;
            end else begin
                pht[train_pc ^ train_history] <= (pht[train_pc ^ train_history] == 2'b00)? 2'b00 : pht[train_pc ^ train_history] - 1;
            end
            if (train_mispredicted) begin
                history <= train_history;
            end
        end

        // History update logic
        if (!train_valid || !train_mispredicted) begin
            history <= predicted_history;
        end
    end
end

endmodule