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
    wire update_enable = train_mispredicted | predict_valid;

    // Next state logic using shift operators for synthesis-friendly shift register style
    always @(*) begin
        if (train_mispredicted) begin
            next_history = (train_history << 1) | train_taken;
        end else if (predict_valid) begin
            next_history = (history << 1) | predict_taken;
        end else begin
            next_history = history;
        end
    end

    // State register with async reset and update enable for power optimization
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else if (update_enable) begin
            history <= next_history;
        end
        // else retain current history value
    end

    assign predict_history = history;

endmodule