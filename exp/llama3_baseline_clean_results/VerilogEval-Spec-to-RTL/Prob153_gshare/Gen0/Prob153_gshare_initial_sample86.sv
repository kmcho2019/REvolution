module TopModule(
    input clk,
    input areset,
    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,
    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

reg [6:0] global_history;
reg [1:0] pht [127:0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b00;
        end
    end else begin
        if (train_valid) begin
            if (train_mispredicted) begin
                global_history <= train_history;
            end
            // Calculate index
            reg [6:0] index;
            index = predict_pc ^ global_history;
            // Update PHT
            if (train_taken) begin
                if (pht[index] != 2'b11) begin
                    pht[index] <= pht[index] + 2'b01;
                end
            end else begin
                if (pht[index] != 2'b00) begin
                    pht[index] <= pht[index] - 2'b01;
                end
            end
        end
        if (predict_valid) begin
            // Predict
            reg [6:0] index;
            index = predict_pc ^ global_history;
            predict_taken <= (pht[index] == 2'b11 || pht[index] == 2'b10);
            predict_history <= global_history;
            // Update global history
            if (predict_taken) begin
                global_history[0] <= 1'b1;
            end else begin
                global_history[0] <= 1'b0;
            end
            global_history[6:1] <= global_history[5:0];
        end
    end
end

endmodule