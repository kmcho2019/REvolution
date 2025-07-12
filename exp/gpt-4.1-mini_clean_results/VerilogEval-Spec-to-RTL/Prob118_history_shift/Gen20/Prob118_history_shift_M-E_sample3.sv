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

    reg [31:0] history_mem;
    reg [4:0]  ptr; // pointer to youngest bit (0 to 31)

    // Helper function to assemble output so predict_history[0] = youngest bit at ptr
    // Returns a rotated version of history_mem so that bit at ptr is LSB
    function [31:0] rotate_right;
        input [31:0] data;
        input [4:0]  shift;
        begin
            // rotate right by shift bits
            rotate_right = (data >> shift) | (data << (32 - shift));
        end
    endfunction

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_mem <= 32'b0;
            ptr <= 5'd0;
            predict_history <= 32'b0;
        end else if (train_mispredicted) begin
            // Load corrected 33-bit history: {train_history, train_taken}
            // Store lower 32 bits in history_mem; youngest bit at ptr=31
            // We set ptr to 31 indicating youngest bit at bit 31
            history_mem <= {train_history, train_taken}[31:0]; 
            // Note: the concatenation is 33 bits, but only 32 stored; youngest bit is at LSB position (index 0),
            // so placing at history_mem bits [0:31], youngest bit is at position 0.
            // But we want pointer = 31 indicating that youngest bit is at position 31.
            // So we rotate history so that youngest bit is at position 31 internally:
            // Let's do rotation here to have youngest bit at bit 31:
            // So do: rotate_left by 1 (mod 32)
            // The data to store: {train_history, train_taken} is 33 bits,
            // take lower 32 bits: bits [31:0]
            // but youngest bit is train_taken at LSB, so bit0 = train_taken (youngest)
            // To put youngest bit at bit 31, rotate left by 1: (rotate_right by 31)
            history_mem <= (({train_history, train_taken}[31:0] << 1) | ({train_history, train_taken}[32]));
            ptr <= 5'd31;
            predict_history <= 32'b0; // Will update below in always_comb
        end else if (predict_valid) begin
            // advance pointer by one modulo 32
            ptr <= (ptr + 5'd1) & 5'd31;
            // write new youngest bit at ptr position
            history_mem <= (history_mem & ~(32'b1 << ((ptr + 1) & 5'd31))) | (predict_taken << ((ptr + 1) & 5'd31));
            // predict_history updated below
        end
        // else hold state
    end

    always @(*) begin
        // Output is history rotated so that youngest bit is at LSB (predict_history[0])
        // pointer points to youngest bit position
        predict_history = rotate_right(history_mem, ptr);
    end

endmodule