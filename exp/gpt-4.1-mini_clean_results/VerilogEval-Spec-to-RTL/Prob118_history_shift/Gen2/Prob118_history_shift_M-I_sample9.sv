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
    wire       update_en;

    // Enable update only on misprediction or valid prediction
    assign update_en = train_mispredicted | predict_valid;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else if (update_en) begin
            if (train_mispredicted) begin
                history <= {train_history[30:0], train_taken};
            end else begin
                history <= {history[30:0], predict_taken};
            end
        end
        // else hold the current history (no toggle)
    end

    assign predict_history = history;

endmodule