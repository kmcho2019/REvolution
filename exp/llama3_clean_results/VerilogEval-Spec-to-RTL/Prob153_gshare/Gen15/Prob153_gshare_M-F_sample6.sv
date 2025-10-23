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
reg [6:0] next_history;

wire [6:0] predict_index = predict_pc ^ history;
wire [6:0] train_index = train_pc ^ train_history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else begin
        // Initialize next_history
        next_history <= history;

        // Prediction pipeline
        if (predict_valid &&!train_valid) begin
            predict_taken <= (pht[predict_index] >= 2'b10);
            predict_history <= history;
            next_history <= {history[5:0], (pht[predict_index] >= 2'b10)};
        end else if (predict_valid && train_valid) begin
            predict_taken <= (pht[predict_index] >= 2'b10);
            predict_history <= history;
            // No update of next_history in this case
        end else if (!predict_valid) begin
            // No update needed
        end

        // Training pipeline
        if (train_valid) begin
            if (train_taken) begin
                pht[train_index] <= (pht[train_index] == 2'b11)? 2'b11 : pht[train_index] + 1;
            end else begin
                pht[train_index] <= (pht[train_index] == 2'b00)? 2'b00 : pht[train_index] - 1;
            end
            if (train_mispredicted) begin
                next_history <= train_history;
            end else if (!predict_valid) begin
                next_history <= {train_history[5:0], train_taken};
            end
        end

        history <= next_history;
    end
end

endmodule