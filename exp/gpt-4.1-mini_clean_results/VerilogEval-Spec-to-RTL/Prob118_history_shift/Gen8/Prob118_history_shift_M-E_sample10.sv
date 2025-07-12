module TopModule (
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output [31:0] predict_history
);
    reg [31:0] history_reg;
    reg  [4:0] ptr; // pointer to youngest bit position (0-31)

    // Update pointer modulo 32
    wire [4:0] ptr_next = (ptr == 5'd31) ? 5'd0 : ptr + 5'd1;

    // Function to rotate the history so that predict_history[0] is youngest
    function [31:0] rotate_history;
        input [31:0] data;
        input [4:0]  rot;
        begin
            // Rotate right by rot bits
            rotate_history = (data >> rot) | (data << (32 - rot));
        end
    endfunction

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
            ptr <= 5'd0;
        end else if (train_mispredicted) begin
            // Load corrected history: train_history concatenated with train_taken as LSB
            // Since predict_history[0] is youngest branch, the oldest bit is train_history[31]
            // So construct as {train_history[30:0], train_taken}
            // But here we reload shifted one bit left by adding train_taken at LSB, reset pointer
            history_reg <= {train_history[30:0], train_taken};
            ptr <= 5'd0;
        end else if (predict_valid) begin
            // Update bit at current pointer position with predict_taken
            // Use bitmask to replace bit
            history_reg <= (history_reg & ~(32'b1 << ptr)) | (predict_taken << ptr);
            // Move pointer to next bit
            ptr <= ptr_next;
        end
        // else retain history_reg and ptr
    end

    // Output rotated history so that predict_history[0] is youngest branch at ptr position
    assign predict_history = rotate_history(history_reg, ptr);

endmodule