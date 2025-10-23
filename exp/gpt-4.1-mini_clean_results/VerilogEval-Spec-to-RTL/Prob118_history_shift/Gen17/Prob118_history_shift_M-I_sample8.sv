module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output [31:0]  predict_history
);

    reg [31:0] history_buffer;  // Circular buffer holding history bits
    reg [4:0]  pointer;         // Points to the index of the youngest bit in buffer (0-31)

    // Write logic on clock
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_buffer <= 32'b0;
            pointer <= 5'd0;
        end else if (train_mispredicted) begin
            // On misprediction, load corrected history:
            // corrected history = train_history concatenated with train_taken as youngest bit (LSB)
            // So buffer[0] = youngest bit, buffer[31] = oldest bit
            // We store it directly in buffer, pointer resets to 0
            history_buffer <= {train_history[31:1], train_taken};
            pointer <= 5'd0;
        end else if (predict_valid) begin
            // Update circular buffer: insert predict_taken at position pointed by pointer
            // Then increment pointer modulo 32
            history_buffer[pointer] <= predict_taken;
            pointer <= pointer + 1;
        end
        // else hold state
    end

    // Output reconstruction by rotating buffer so pointer is youngest bit at LSB
    // pointer points to youngest bit position
    // So predict_history[0] = history_buffer[pointer]
    // predict_history = circular right rotate of history_buffer by pointer positions

    wire [31:0] rotated_history;
    assign rotated_history = (history_buffer >> pointer) | (history_buffer << (32 - pointer));
    assign predict_history = rotated_history;

endmodule