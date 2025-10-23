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

    reg [31:0] history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else if (train_mispredicted) begin
            // On misprediction, restore from train_history and append actual taken
            history <= {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // Normal prediction: shift in new prediction
            history <= {history[30:0], predict_taken};
        end
    end

    assign predict_history = history;

endmodule