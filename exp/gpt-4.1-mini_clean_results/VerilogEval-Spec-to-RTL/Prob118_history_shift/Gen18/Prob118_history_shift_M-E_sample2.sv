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

    reg [31:0] next_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
            next_history <= 32'b0;
        end else if (train_mispredicted) begin
            // On misprediction, immediately update history with corrected value
            predict_history <= {train_history[30:0], train_taken};
            next_history <= {train_history[30:0], train_taken};
        end else begin
            // On no misprediction
            predict_history <= next_history; // update history with next_history
            if (predict_valid) begin
                // Prepare next history for prediction shift in
                next_history <= {next_history[30:0], predict_taken};
            end else begin
                next_history <= next_history; // hold
            end
        end
    end

endmodule