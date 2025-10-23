module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output [31:0] predict_history
);

    reg [31:0] main_history;
    reg [31:0] speculative_history;
    reg prediction_in_flight;

    // Output the speculative history for predictions
    assign predict_history = speculative_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            main_history <= 32'b0;
            speculative_history <= 32'b0;
            prediction_in_flight <= 1'b0;
        end else begin
            // Handle mispredictions (highest priority)
            if (train_mispredicted) begin
                main_history <= {train_history[30:0], train_taken};
                speculative_history <= {train_history[30:0], train_taken};
                prediction_in_flight <= 1'b0;
            end
            // Commit previous prediction if no misprediction
            else if (prediction_in_flight) begin
                main_history <= speculative_history;
                prediction_in_flight <= 1'b0;
            end

            // Handle new predictions
            if (predict_valid && !train_mispredicted) begin
                speculative_history <= {speculative_history[30:0], predict_taken};
                prediction_in_flight <= 1'b1;
            end
        end
    end

endmodule