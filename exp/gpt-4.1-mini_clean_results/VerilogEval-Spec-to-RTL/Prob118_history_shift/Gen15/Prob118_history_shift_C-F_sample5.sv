module TopModule(
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output [31:0]  predict_history
);

    reg [31:0] history;

    // Clock enable to reduce toggling: update only on misprediction or prediction valid
    wire update_enable = train_mispredicted | predict_valid;

    // Next state logic with priority to misprediction load
    wire [31:0] load_history = {train_history[30:0], train_taken};
    wire [31:0] shift_history = {history[30:0], predict_taken};

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else if (update_enable) begin
            if (train_mispredicted) begin
                history <= load_history;        // rollback on misprediction
            end else begin
                history <= shift_history;       // shift on prediction only if no misprediction
            end
        end
        // else hold current history to reduce toggling
    end

    assign predict_history = history;

endmodule