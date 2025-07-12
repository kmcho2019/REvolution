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

    reg [31:0] current_history;
    reg [31:0] shadow_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_history <= 32'b0;
            shadow_history <= 32'b0;
        end else if (train_mispredicted) begin
            // Rollback: reconstruct history from train_history + actual taken
            current_history <= {train_history[30:0], train_taken};
            shadow_history <= train_history; // Update shadow to match
        end else if (predict_valid) begin
            // Normal prediction: shift in new bit and update shadow
            shadow_history <= current_history;
            current_history <= {current_history[30:0], predict_taken};
        end
    end

    assign predict_history = current_history;

endmodule