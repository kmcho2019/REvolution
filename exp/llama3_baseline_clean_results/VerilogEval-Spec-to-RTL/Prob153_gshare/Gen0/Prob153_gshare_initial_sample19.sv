module TopModule(
    input               clk,
    input               areset,

    input               predict_valid,
    input       [6:0]   predict_pc,
    output              predict_taken,
    output      [6:0]   predict_history,

    input               train_valid,
    input               train_taken,
    input               train_mispredicted,
    input       [6:0]   train_history,
    input       [6:0]   train_pc
);

reg [6:0] branch_history;
reg [127:0][1:0] pht;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        branch_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else begin
        // Update branch history register for training
        if (train_valid && train_mispredicted) begin
            branch_history <= train_history;
        end else if (predict_valid) begin
            // Update branch history register for prediction
            if (predict_taken) begin
                branch_history[6] <= predict_pc[6] ^ branch_history[6];
            end else begin
                branch_history[6] <= branch_history[6];
            end
            for (int i = 5; i >= 0; i--) begin
                branch_history[i] <= branch_history[i+1];
            end
        end
    end
end

reg predict_taken_reg;
always @(*) begin
    // Calculate index for PHT
    reg [6:0] index;
    index = {predict_pc[6:0] ^ branch_history[6:0]};
    if (index >= 128) begin
        $display("Index out of range");
    end else begin
        // Predict taken if PHT value is greater than or equal to 2
        if (pht[index] >= 2'b10) begin
            predict_taken_reg = 1'b1;
        end else begin
            predict_taken_reg = 1'b0;
        end
    end
end

assign predict_taken = predict_taken_reg;
assign predict_history = branch_history;

always @(posedge clk) begin
    if (train_valid) begin
        // Update PHT based on actual branch outcome
        reg [6:0] index;
        index = {train_pc[6:0] ^ train_history[6:0]};
        if (index >= 128) begin
            $display("Index out of range");
        end else if (train_taken) begin
            // Increment PHT value if branch was taken
            if (pht[index] < 2'b11) begin
                pht[index] <= pht[index] + 1;
            end
        end else begin
            // Decrement PHT value if branch was not taken
            if (pht[index] > 2'b00) begin
                pht[index] <= pht[index] - 1;
            end
        end
    end
end

endmodule