module TopModule (
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

reg [6:0] branch_history;
reg [6:0] branch_history_next;
reg [1:0] pht [127:0];
reg [1:0] pht_next [127:0];

assign predict_history = branch_history;

always @(*) begin
    // Calculate the index into the PHT
    reg [6:0] index;
    index = predict_pc ^ branch_history;

    // Make a prediction
    if (pht[index] >= 2'b10) begin
        predict_taken = 1'b1;
    end else begin
        predict_taken = 1'b0;
    end

    // Update the branch history register for the predicted branch
    if (predict_valid) begin
        if (predict_taken) begin
            branch_history_next = {branch_history[5:0], 1'b1};
        end else begin
            branch_history_next = {branch_history[5:0], 1'b0};
        end
    end else begin
        branch_history_next = branch_history;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        branch_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else begin
        // Update the branch history register
        if (train_mispredicted && train_valid) begin
            branch_history <= train_history;
        end else if (predict_valid) begin
            branch_history <= branch_history_next;
        end

        // Update the PHT
        if (train_valid) begin
            reg [6:0] index;
            index = train_pc ^ train_history;
            if (train_taken) begin
                if (pht[index] != 2'b11) begin
                    pht[index] <= pht[index] + 1'b1;
                end
            end else begin
                if (pht[index] != 2'b00) begin
                    pht[index] <= pht[index] - 1'b1;
                end
            end
        end
    end
end

endmodule