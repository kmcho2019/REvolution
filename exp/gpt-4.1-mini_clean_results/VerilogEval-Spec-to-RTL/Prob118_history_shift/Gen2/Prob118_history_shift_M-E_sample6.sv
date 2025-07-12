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

reg [31:0] speculative_history;
reg [31:0] committed_history;

assign predict_history = speculative_history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        committed_history  <= 32'b0;
        speculative_history <= 32'b0;
    end else begin
        if (train_mispredicted) begin
            // Roll back speculative history to committed + actual branch outcome
            speculative_history <= {train_history[30:0], train_taken};
            // Update committed history to rollback state (before mispredicted branch)
            committed_history <= train_history;
        end else if (predict_valid) begin
            // Shift in predicted taken bit speculatively
            speculative_history <= {speculative_history[30:0], predict_taken};
            // Committed history remains unchanged until confirmed
        end
    end
end

endmodule