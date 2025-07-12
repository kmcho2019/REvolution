module TopModule (
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output reg [31:0] predict_history
);

function [31:0] compute_next_history;
    input [31:0] current_history;
    input        predict_valid_f;
    input        predict_taken_f;
    input        train_mispredicted_f;
    input [31:0] train_history_f;
    input        train_taken_f;
    begin
        if (train_mispredicted_f) begin
            // Load corrected history: old history + actual taken bit
            compute_next_history = {train_history_f[30:0], train_taken_f};
        end else if (predict_valid_f) begin
            // Shift in prediction taken bit
            compute_next_history = {current_history[30:0], predict_taken_f};
        end else begin
            // No update
            compute_next_history = current_history;
        end
    end
endfunction

always @(posedge clk or posedge areset) begin
    if (areset) begin
        predict_history <= 32'b0;
    end else begin
        predict_history <= compute_next_history(predict_history, predict_valid, predict_taken,
                                                train_mispredicted, train_history, train_taken);
    end
end

endmodule