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
            // Update history register when training and mispredicted
            history <= train_history;
        end else if (predict_valid) begin
            // Update history register when predicting and not mispredicted
            if (predict_taken) begin
                history <= {history[5:0], 1'b1};
            end else begin
                history <= {history[5:0], 1'b0};
            end
        end

        if (train_valid) begin
            // Update PHT when training
            reg [6:0] index = train_pc ^ train_history;
            if (index >= 128) begin
                // Handle out-of-bounds access
                index = 127;
            end
            if (train_taken) begin
                pht[index] <= (pht[index] == 2'b11)? 2'b11 : pht[index] + 1;
            end else begin
                pht[index] <= (pht[index] == 2'b00)? 2'b00 : pht[index] - 1;
            end
        end

        if (predict_valid) begin
            // Update prediction outputs
            reg [6:0] index = predict_pc ^ history;
            if (index >= 128) begin
                // Handle out-of-bounds access
                index = 127;
            end
            if (pht[index] >= 2'b10) begin
                predict_taken <= 1'b1;
            end else begin
                predict_taken <= 1'b0;
            end
            predict_history <= history;
        end
    end
end

endmodule