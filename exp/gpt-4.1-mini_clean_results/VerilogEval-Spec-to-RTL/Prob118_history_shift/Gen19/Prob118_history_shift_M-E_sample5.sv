module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output reg [31:0] predict_history
);

    reg [31:0] history_reg;       // stored bits, not necessarily in linear order
    reg [4:0]  pointer;           // points to youngest bit position in history_reg

    // Helper function to perform circular read of history_reg starting from pointer
    function [31:0] get_linear_history;
        input [31:0] hist;
        input [4:0] ptr;
        integer i;
        begin
            for (i=0; i<32; i=i+1) begin
                get_linear_history[i] = hist[(ptr + i) & 5'd31];
            end
        end
    endfunction

    // Helper function to build corrected history in circular buffer format from linear input
    // Since on misprediction, we receive linear corrected history: 
    // corrected = {train_history, train_taken} shifted accordingly
    // We'll store it with pointer=0, meaning youngest bit at position 0.
    // This means history_reg = corrected history bits directly.
    // Because pointer=0, get_linear_history will output history_reg as-is.
    // So we form linear corrected history first:
    // The spec states that corrected history = train_history concatenated with train_taken at LSB (youngest)
    // So corrected_history_linear[0] = train_taken
    // corrected_history_linear[31:1] = train_history[30:0]
    // train_history[31] is older branch, not included in corrected_history_linear
    // So length is 32 bits: 1 (train_taken) + 31 bits from train_history[30:0]
    // train_history[31] is discarded (oldest is dropped)
    // We shift train_history left by 1 and put train_taken at LSB.
    wire [31:0] corrected_history_linear;
    assign corrected_history_linear = {train_history[30:0], train_taken};

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'd0;
            pointer <= 5'd0;
            predict_history <= 32'd0;
        end else if (train_mispredicted) begin
            // On misprediction, load corrected history linearly into history_reg
            history_reg <= corrected_history_linear;
            pointer <= 5'd0;
            predict_history <= corrected_history_linear;
        end else if (predict_valid) begin
            // Write predict_taken bit at pointer position, advance pointer circularly
            history_reg[pointer] <= predict_taken;
            pointer <= pointer + 5'd1; // wraps automatically due to 5-bit width
            // Update output by reading history linearly from new pointer (pointer+1)
            // But note pointer updated after write, so current pointer points to next youngest
            predict_history <= get_linear_history(history_reg, pointer + 5'd1);
        end else begin
            // No change, keep predict_history as last
            predict_history <= predict_history;
        end
    end

endmodule