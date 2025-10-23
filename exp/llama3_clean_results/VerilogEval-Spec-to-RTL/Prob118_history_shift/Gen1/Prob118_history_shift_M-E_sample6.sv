module TopModule (
    input  clk,
    input  areset,
    input  predict_valid,
    input  predict_taken,
    input  train_mispredicted,
    input  train_taken,
    input  [31:0] train_history,
    output [31:0] predict_history
);

reg [31:0] fifo[31:0];
reg [4:0] head, tail;
reg [31:0] temp_history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        head <= 5'd0;
        tail <= 5'd0;
        for (int i = 0; i < 32; i++) begin
            fifo[i] <= 1'b0;
        end
    end else if (train_mispredicted) begin
        // Load corrected history into the FIFO
        temp_history = {train_history, train_taken};
        for (int i = 0; i < 32; i++) begin
            fifo[(head + i) % 32] <= temp_history[i];
        end
    end else if (predict_valid) begin
        // Shift in new prediction
        fifo[tail] <= predict_taken;
        tail <= (tail + 1) % 32;
    end
end

always @(*) begin
    predict_history = 32'd0;
    for (int i = 0; i < 32; i++) begin
        predict_history[i] = fifo[(head + i) % 32];
    end
end

endmodule