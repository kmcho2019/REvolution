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
    wire reg_enable = areset || train_mispredicted || predict_valid;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_history <= 32'b0;
            shadow_history <= 32'b0;
        end else if (reg_enable) begin
            if (train_mispredicted) begin
                // Rollback case: reconstruct from train_history + actual taken
                current_history <= {train_history[30:0], train_taken};
                shadow_history <= train_history; // Keep shadow synchronized
            end else if (predict_valid) begin
                // Prediction case: shift in new bit and update shadow
                shadow_history <= current_history;
                current_history <= {current_history[30:0], predict_taken};
            end
        end
    end

    assign predict_history = current_history;

endmodule