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
reg [6:0] predict_index;
reg [6:0] train_index;
reg [1:0] predict_pht_value;

always @(*) begin
    predict_index = predict_pc ^ history;
    train_index = train_pc ^ train_history;
    predict_pht_value = pht[predict_index];
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else begin
        // Handle prediction
        if (predict_valid) begin
            predict_taken <= (predict_pht_value >= 2'b10);
            predict_history <= history;
        end

        // Handle training
        if (train_valid) begin
            if (train_mispredicted) begin
                // Update history register immediately for misprediction
                history <= train_history;
            end else if (predict_valid) begin
                // Update history register based on predicted outcome
                history <= {history[5:0], predict_taken};
            end

            // Update PHT
            if (train_taken) begin
                if (pht[train_index]!= 2'b11) begin
                    pht[train_index] <= pht[train_index] + 1;
                end
            end else begin
                if (pht[train_index]!= 2'b00) begin
                    pht[train_index] <= pht[train_index] - 1;
                end
            end
        end else if (!train_valid && predict_valid) begin
            // Update history register based on predicted outcome
            history <= {history[5:0], predict_taken};
        end
    end
end

endmodule