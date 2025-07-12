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
reg [3:0] perceptron_weights [127:0];
reg [6:0] history;
reg [6:0] gshare_index;
reg [6:0] perceptron_index;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            gshare_pht[i] <= 2'b0;
            perceptron_weights[i] <= 4'b0;
        end
    end else begin
        if (train_valid && train_mispredicted) begin
            // Update history register when training and mispredicted
            history <= train_history;
        end else if (predict_valid && !train_valid) begin
            // Update history register when predicting and not training
            if (gshare_pht[(predict_pc ^ history) % 128] >= 2'b10) begin
                history <= {history[5:0], 1'b1};
            end else begin
                history <= {history[5:0], 1'b0};
            end
        end

        if (train_valid) begin
            // Update PHT when training
            reg [6:0] index = train_pc ^ train_history;
            index = index % 128; // Handle out-of-bounds access using modulo
            if (train_taken) begin
                gshare_pht[index] <= (gshare_pht[index] == 2'b11)? 2'b11 : gshare_pht[index] + 1;
            end else begin
                gshare_pht[index] <= (gshare_pht[index] == 2'b00)? 2'b00 : gshare_pht[index] - 1;
            end

            // Update perceptron weights
            reg [6:0] perceptron_index = train_pc % 128;
            reg [3:0] perceptron_output;
            perceptron_output = (perceptron_weights[perceptron_index] * train_history) + (perceptron_weights[perceptron_index] * train_pc);
            if (perceptron_output >= 4'b1000) begin
                perceptron_output = 4'b1000;
            end else if (perceptron_output <= 4'b0000) begin
                perceptron_output = 4'b0000;
            end

            if (train_taken) begin
                perceptron_weights[perceptron_index] <= (perceptron_weights[perceptron_index] == 4'b1111)? 4'b1111 : perceptron_weights[perceptron_index] + 1;
            end else begin
                perceptron_weights[perceptron_index] <= (perceptron_weights[perceptron_index] == 4'b0000)? 4'b0000 : perceptron_weights[perceptron_index] - 1;
            end
        end

        if (predict_valid) begin
            // Update prediction outputs
            reg [6:0] index = predict_pc ^ history;
            index = index % 128; // Handle out-of-bounds access using modulo
            if (gshare_pht[index] >= 2'b10) begin
                predict_taken <= 1'b1;
            end else begin
                predict_taken <= 1'b0;
            end

            // Use perceptron tables for prediction
            reg [6:0] perceptron_index = predict_pc % 128;
            reg [3:0] perceptron_output;
            perceptron_output = (perceptron_weights[perceptron_index] * history) + (perceptron_weights[perceptron_index] * predict_pc);
            if (perceptron_output >= 4'b1000) begin
                perceptron_output = 4'b1000;
            end else if (perceptron_output <= 4'b0000) begin
                perceptron_output = 4'b0000;
            end

            if (perceptron_output >= 4'b1000) begin
                predict_taken <= 1'b1;
            end else begin
                predict_taken <= 1'b0;
            end

            predict_history <= history;
        end
    end
end

endmodule