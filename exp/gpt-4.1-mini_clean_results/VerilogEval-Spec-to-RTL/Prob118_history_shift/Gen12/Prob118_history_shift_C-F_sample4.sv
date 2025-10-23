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

    reg [31:0] history_reg;
    wire [31:0] next_history;
    wire        update_enable;

    // Determine next history state with priority: misprediction > prediction > hold
    assign next_history = train_mispredicted ? {train_history[30:0], train_taken} :
                          predict_valid    ? {history_reg[30:0], predict_taken} :
                                             history_reg;

    // Enable updating the register only when misprediction or prediction occurs
    assign update_enable = train_mispredicted | predict_valid;

    // Output the current history
    assign predict_history = history_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0; // Asynchronous reset clears history
        end else if (update_enable) begin
            history_reg <= next_history; // Update only on valid events
        end
        // else hold current history (no clock gating needed since register only updates conditionally)
    end

endmodule