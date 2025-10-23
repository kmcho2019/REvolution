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

    reg [31:0] history, next_history;
    reg        update_enable;

    // Next state combinational logic with priority: misprediction > prediction > hold
    always @(*) begin
        if (train_mispredicted) begin
            next_history = {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            next_history = {history[30:0], predict_taken};
        end else begin
            next_history = history;
        end
    end

    // Enable update only when history would change to reduce switching (power optimization)
    always @(*) begin
        update_enable = (next_history != history);
    end

    // Sequential logic: async reset, update history only when enabled
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else if (update_enable) begin
            history <= next_history;
        end
    end

    assign predict_history = history;

endmodule