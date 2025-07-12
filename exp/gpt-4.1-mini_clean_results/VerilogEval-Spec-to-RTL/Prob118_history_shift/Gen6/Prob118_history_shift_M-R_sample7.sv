module TopModule (
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output [31:0] predict_history
);

    reg [31:0] history_reg;
    reg [31:0] next_history;

    // Output assignment reflects current history
    assign predict_history = history_reg;

    always @(*) begin
        // Default next state holds current value
        next_history = history_reg;

        // Priority: misprediction rollback over prediction update
        if (train_mispredicted) begin
            // Roll back to corrected history: take lower 31 bits of train_history plus train_taken LSB
            // Problem states: rollback history = train_history (32 bits) concatenated with train_taken,
            // but output is 32 bits, so we keep lower 31 bits of train_history and append train_taken
            next_history = {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // Shift in predicted branch outcome
            next_history = {history_reg[30:0], predict_taken};
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            history_reg <= 32'b0;
        else
            history_reg <= next_history;
    end

endmodule