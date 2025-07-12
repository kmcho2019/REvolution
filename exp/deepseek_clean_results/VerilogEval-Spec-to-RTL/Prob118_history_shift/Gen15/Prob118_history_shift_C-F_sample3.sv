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
            // Priority: misprediction recovery
            current_history <= {train_history[30:0], train_taken};
            // shadow_history remains unchanged (power optimization)
        end else if (predict_valid) begin
            // Normal prediction update
            shadow_history <= current_history;  // Capture pre-update state
            current_history <= {current_history[30:0], predict_taken};
        end
    end

    assign predict_history = current_history;

endmodule