module TopModule (
    input           clk,
    input           areset,
    input           predict_valid,
    input           predict_taken,
    input           train_mispredicted,
    input           train_taken,
    input   [31:0]  train_history,
    output reg [31:0] predict_history
);

    // Update enable: only update history on valid prediction or rollback due to misprediction
    wire update_enable = train_mispredicted | predict_valid;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (update_enable) begin
            if (train_mispredicted) begin
                // Rollback: load history before mispredicted branch plus actual result
                predict_history <= {train_history[30:0], train_taken};
            end else begin
                // Normal prediction update: shift in predicted taken bit
                predict_history <= {predict_history[30:0], predict_taken};
            end
        end
        // else hold current predict_history
    end

endmodule