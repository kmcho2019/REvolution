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
    reg last_predict_taken;  // Stores only the last prediction for reconstruction

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_history <= 32'b0;
            last_predict_taken <= 1'b0;
        end else if (train_mispredicted) begin
            // Reconstruct history by combining:
            // 1. Older history from pipeline (train_history)
            // 2. Actual outcome of mispredicted branch (train_taken)
            // 3. Newer predictions that were correct (current_history[30:0])
            current_history <= {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // Normal prediction update
            last_predict_taken <= predict_taken;
            current_history <= {current_history[30:0], predict_taken};
        end
    end

    assign predict_history = current_history;

endmodule