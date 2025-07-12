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

    wire load_enable = train_mispredicted;       // Parallel load on misprediction
    wire shift_enable = !train_mispredicted && predict_valid; // Shift on prediction only if no misprediction

    // Next value for history
    wire [31:0] loaded_history = {train_history[30:0], train_taken};
    wire [31:0] shifted_history = {history[30:0], predict_taken};

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else if (load_enable) begin
            history <= loaded_history;  // Load rollback history on misprediction
        end else if (shift_enable) begin
            history <= shifted_history; // Shift in predicted branch direction
        end
        // else hold the current history value
    end

    assign predict_history = history;

endmodule