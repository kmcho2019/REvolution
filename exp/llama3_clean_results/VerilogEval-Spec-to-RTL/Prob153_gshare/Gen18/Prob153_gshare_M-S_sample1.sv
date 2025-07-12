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

wire [6:0] predict_index = predict_pc ^ history;
wire [6:0] train_index = train_pc ^ train_history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01; // Initialize to weakly taken
        end
    end else begin
        // Prediction
        if (predict_valid) begin
            predict_taken <= (pht[predict_index] >= 2'b10);
            predict_history <= history;
        end

        // Update history
        if (train_valid && train_mispredicted) begin
            history <= train_history;
        end else if (train_valid && !train_mispredicted) begin
            // Do nothing, let prediction handle it
        end else if (predict_valid && !train_valid) begin
            history <= {history[5:0], (pht[predict_index] >= 2'b10)};
        end else if (!predict_valid && !train_valid) begin
            // Do nothing, history should not change
        end

        // Training
        if (train_valid) begin
            if (train_taken) begin
                pht[train_index] <= (pht[train_index] == 2'b11) ? 2'b11 : pht[train_index] + 1;
            end else begin
                pht[train_index] <= (pht[train_index] == 2'b00) ? 2'b00 : pht[train_index] - 1;
            end
        end
    end
end

endmodule