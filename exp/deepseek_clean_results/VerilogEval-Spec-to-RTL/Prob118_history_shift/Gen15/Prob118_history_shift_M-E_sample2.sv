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
    reg [4:0] write_ptr;  // Points to current insertion position (0-31)
    reg [4:0] saved_ptr;  // For misprediction recovery

    // Circular buffer reconstruction logic
    wire [31:0] circular_history;
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : reconstruct
            assign circular_history[i] = history_buffer[(write_ptr + i + 1) % 32];
        end
    endgenerate

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_buffer <= 32'b0;
            write_ptr <= 5'b0;
            saved_ptr <= 5'b0;
        end else if (train_mispredicted) begin
            // Reconstruct history from train_history + actual taken
            history_buffer <= {train_history[30:0], train_taken};
            write_ptr <= 5'd31;  // Point to last position
            saved_ptr <= 5'd31;
        end else if (predict_valid) begin
            // Update current position and advance pointer
            history_buffer[write_ptr] <= predict_taken;
            write_ptr <= (write_ptr == 5'd31) ? 5'b0 : write_ptr + 1;
            saved_ptr <= write_ptr;  // Save for potential misprediction
        end
    end

    // Output is the reconstructed linear history
    assign predict_history = circular_history;

endmodule