module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output [31:0]  predict_history
);

    reg [31:0] history;
    reg        update_enable;
    reg [31:0] next_history;

    // Determine next history value and update enable signal
    always @(*) begin
        if (train_mispredicted) begin
            // Misprediction rollback has priority
            next_history = {train_history[30:0], train_taken};
            update_enable = 1'b1;
        end else if (predict_valid) begin
            // Shift in predicted taken bit
            next_history = {history[30:0], predict_taken};
            update_enable = 1'b1;
        end else begin
            // No update
            next_history = history;
            update_enable = 1'b0;
        end
    end

    // Sequential update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else if (update_enable) begin
            history <= next_history;
        end
    end

    assign predict_history = history;

endmodule