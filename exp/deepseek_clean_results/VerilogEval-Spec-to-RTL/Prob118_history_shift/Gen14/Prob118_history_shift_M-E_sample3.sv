module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    output [31:0] predict_history
);

    reg [31:0] current_history;
    reg [31:0] recovery_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_history <= 32'b0;
            recovery_history <= 32'b0;
        end else begin
            // Recovery register tracks state before prediction updates
            if (predict_valid) begin
                recovery_history <= current_history;
            end

            // Current history updates with priority to misprediction
            if (train_mispredicted) begin
                current_history <= {recovery_history[30:0], train_taken};
            end else if (predict_valid) begin
                current_history <= {current_history[30:0], predict_taken};
            end
        end
    end

    assign predict_history = current_history;

endmodule