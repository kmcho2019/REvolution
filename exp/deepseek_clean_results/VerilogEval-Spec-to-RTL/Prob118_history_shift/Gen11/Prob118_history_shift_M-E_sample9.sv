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

    reg [31:0] history_buffer;
    reg [4:0] head_ptr;  // Points to current youngest bit

    // Circular buffer implementation
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_buffer <= 32'b0;
            head_ptr <= 5'b0;
        end else if (train_mispredicted) begin
            // Load train_history with train_taken at position 0
            history_buffer <= {train_history[30:0], train_taken};
            head_ptr <= 5'd31;  // Newest bit is at position 31
        end else if (predict_valid) begin
            // Write predict_taken at next position (circular)
            history_buffer[head_ptr + 1] <= predict_taken;
            head_ptr <= head_ptr + 1;
        end
    end

    // Generate output by rotating based on head pointer
    assign predict_history = {history_buffer, history_buffer} >> (31 - head_ptr);

endmodule