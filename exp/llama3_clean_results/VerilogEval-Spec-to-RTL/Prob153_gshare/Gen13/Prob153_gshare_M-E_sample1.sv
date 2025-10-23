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
reg [6:0] predicted_direction;

wire [6:0] predict_index = predict_pc ^ history;
wire [6:0] train_index = train_pc ^ train_history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        history <= 7'b0;
        predicted_direction <= 1'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else begin
        // Prediction pipeline
        if (predict_valid) begin
            predict_taken <= (pht[predict_index] >= 2'b10);
            predict_history <= history;
            predicted_direction <= (pht[predict_index] >= 2'b10);
        end

        // Training pipeline
        if (train_valid) begin
            if (train_taken) begin
                pht[train_index] <= (pht[train_index] == 2'b11)? 2'b11 : pht[train_index] + 1;
            end else begin
                pht[train_index] <= (pht[train_index] == 2'b00)? 2'b00 : pht[train_index] - 1;
            end
            if (train_mispredicted) begin
                history <= train_history;
            end else if (!predict_valid) begin
                history <= {history[5:0], predicted_direction};
            end
        end else if (predict_valid &&!train_valid) begin
            // Update history register when predicting and not training
            history <= {history[5:0], predicted_direction};
        end
    end
end

endmodule