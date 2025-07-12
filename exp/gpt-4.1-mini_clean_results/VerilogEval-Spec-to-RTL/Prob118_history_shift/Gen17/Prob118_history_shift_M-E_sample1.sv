module TopModule (
    input           clk,
    input           areset,
    input           predict_valid,
    input           predict_taken,
    input           train_mispredicted,
    input           train_taken,
    input   [31:0]  train_history,
    output  reg [31:0] predict_history
);
    reg [31:0] history_reg;
    reg [4:0]  pointer; // points to the position of the youngest bit in history_reg (0-31)

    // Function to rotate history_reg so that pointer index is aligned to LSB (youngest bit at bit 0)
    function [31:0] rotate_right;
        input [31:0] data;
        input [4:0]  rot;
        begin
            rotate_right = (data >> rot) | (data << (32 - rot));
        end
    endfunction

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg   <= 32'b0;
            pointer       <= 5'd0;
            predict_history <= 32'b0;
        end else if (train_mispredicted) begin
            // On misprediction, load history concatenated with train_taken at youngest bit
            // According to spec: predict_history[0] is youngest bit
            // So the corrected history is {train_history, train_taken} with train_taken at LSB (bit 0)
            // We'll store in history_reg as is, pointer resets to 0 so that history_reg[0] = youngest bit
            history_reg   <= {train_history[31:1], train_taken};
            pointer       <= 5'd0;
            predict_history <= {train_history[31:1], train_taken};
        end else if (predict_valid) begin
            // Advance pointer circularly by 1
            pointer <= pointer + 5'd1;
            // Update bit at new pointer position with predict_taken
            // Note: pointer points to the current youngest bit
            history_reg <= (history_reg & ~(32'b1 << (pointer + 1))) | (predict_taken << (pointer + 1));
            // Output rotated so that predict_history[0] is youngest bit at pointer+1
            predict_history <= rotate_right(history_reg, pointer + 1);
        end else begin
            // No update: maintain current state and output
            predict_history <= rotate_right(history_reg, pointer);
        end
    end
endmodule