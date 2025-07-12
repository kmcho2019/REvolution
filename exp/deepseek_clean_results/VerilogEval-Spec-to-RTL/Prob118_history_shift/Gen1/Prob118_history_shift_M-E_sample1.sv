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

    // Circular buffer implementation
    reg [31:0] history_mem [0:31];  // 32-entry memory
    reg [4:0] head_ptr;             // Write pointer
    reg [4:0] tail_ptr;             // Read pointer (always head-31 mod 32)
    reg [4:0] saved_head_ptr;       // For misprediction recovery

    integer i;

    // Output generation
    always @(*) begin
        for (i = 0; i < 32; i = i + 1) begin
            predict_history[i] = history_mem[(tail_ptr + i) % 32];
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize pointers and clear memory
            head_ptr <= 5'd0;
            tail_ptr <= 5'd1;  // Will wrap to 0 on first use
            for (i = 0; i < 32; i = i + 1) begin
                history_mem[i] <= 1'b0;
            end
        end else begin
            if (train_mispredicted) begin
                // Restore history from train_history and append train_taken
                for (i = 0; i < 31; i = i + 1) begin
                    history_mem[i] <= train_history[i];
                end
                history_mem[31] <= train_taken;
                head_ptr <= 5'd31;
                tail_ptr <= 5'd0;
            end else if (predict_valid) begin
                // Normal prediction: write to current head and advance
                history_mem[head_ptr] <= predict_taken;
                head_ptr <= (head_ptr == 5'd31) ? 5'd0 : head_ptr + 1;
                tail_ptr <= (tail_ptr == 5'd31) ? 5'd0 : tail_ptr + 1;
            end
        end
    end

endmodule