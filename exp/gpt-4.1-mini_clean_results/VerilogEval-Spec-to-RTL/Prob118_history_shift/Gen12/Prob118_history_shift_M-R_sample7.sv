module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output reg [31:0] predict_history
);

    wire [31:0] rollback_history;
    wire [31:0] shifted_history;
    wire [31:0] next_predict_history;

    // Rollback history: concatenate train_history (youngest to oldest) and actual taken bit
    assign rollback_history = {train_history[31:1], train_taken};

    // Shifted history on prediction valid
    assign shifted_history = {predict_history[30:0], predict_taken};

    // Next history value: prioritize misprediction rollback
    assign next_predict_history = train_mispredicted ? rollback_history :
                                  (predict_valid ? shifted_history : predict_history);

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            predict_history <= 32'b0;
        else
            predict_history <= next_predict_history;
    end

endmodule