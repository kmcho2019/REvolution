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
    reg [31:0] next_history;
    wire       update_enable;

    assign update_enable = train_mispredicted | predict_valid;

    always @* begin
        if (train_mispredicted) begin
            // On misprediction, load corrected history: oldest 31 bits + actual branch result
            next_history = {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // On prediction, shift in predicted taken bit
            next_history = {history[30:0], predict_taken};
        end else begin
            // No update
            next_history = history;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else if (update_enable) begin
            history <= next_history;
        end
    end

    assign predict_history = history;

endmodule