module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output reg [31:0]  predict_history
);

    wire [31:0] next_history;
    wire update_enable;

    // Update enable when misprediction or prediction occurs
    assign update_enable = train_mispredicted | predict_valid;

    // Next history determined by priority: misprediction overrides prediction
    assign next_history = train_mispredicted ? {train_history[30:0], train_taken} :
                          predict_valid      ? {predict_history[30:0], predict_taken} :
                                              predict_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (update_enable) begin
            predict_history <= next_history;
        end
        // else hold previous predict_history
    end

endmodule