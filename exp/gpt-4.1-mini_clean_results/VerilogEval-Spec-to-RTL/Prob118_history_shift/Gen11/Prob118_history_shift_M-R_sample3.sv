module TopModule(
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output [31:0] predict_history
);

    reg [31:0] history;
    reg        update_enable;
    reg [31:0] data_in;

    // Determine the data to load into the history register before shift
    always @(*) begin
        if (train_mispredicted) begin
            // Load train_history and train_taken as new history, misprediction has priority
            data_in = {train_history[30:0], train_taken};
            update_enable = 1'b1;
        end else if (predict_valid) begin
            // Shift in predict_taken for prediction update
            data_in = {history[30:0], predict_taken};
            update_enable = 1'b1;
        end else begin
            data_in = history;
            update_enable = 1'b0;
        end
    end

    // Synchronous update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else if (update_enable) begin
            history <= data_in;
        end
    end

    assign predict_history = history;

endmodule