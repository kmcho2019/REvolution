module TopModule (
    input           clk,
    input           areset,
    input           predict_valid,
    input           predict_taken,
    input           train_mispredicted,
    input           train_taken,
    input  [31:0]   train_history,
    output reg [31:0] predict_history
);

    // Enable register update only when misprediction or valid prediction
    wire update_enable = train_mispredicted | predict_valid;

    // Next history value depends on priority: rollback if mispredicted, else prediction update
    wire [31:0] next_history = train_mispredicted ? {train_history[30:0], train_taken} :
                               predict_valid     ? {predict_history[30:0], predict_taken} :
                                                   predict_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (update_enable) begin
            predict_history <= next_history;
        end
        // else hold current predict_history
    end

endmodule