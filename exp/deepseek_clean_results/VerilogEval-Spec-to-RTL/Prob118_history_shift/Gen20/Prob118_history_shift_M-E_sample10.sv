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

    reg [4:0] head_ptr;  // Points to current position (0-31)
    reg [31:0] history_buffer [0:31];  // Circular buffer storage

    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize all buffer entries to 0
            for (i = 0; i < 32; i = i + 1) begin
                history_buffer[i] <= 1'b0;
            end
            head_ptr <= 5'd0;
        end else if (train_mispredicted) begin
            // Misprediction recovery - reconstruct history
            for (i = 0; i < 31; i = i + 1) begin
                history_buffer[i] <= train_history[i];
            end
            history_buffer[31] <= train_taken;
            head_ptr <= 5'd31;  // Point to newest entry
        end else if (predict_valid) begin
            // Normal prediction update
            history_buffer[head_ptr] <= predict_taken;
            head_ptr <= (head_ptr == 5'd31) ? 5'd0 : head_ptr + 5'd1;
        end
    end

    // Generate output by reading the circular buffer in order
    genvar j;
    generate
        for (j = 0; j < 32; j = j + 1) begin : history_output
            assign predict_history[j] = history_buffer[(head_ptr + j) % 32];
        end
    endgenerate

endmodule