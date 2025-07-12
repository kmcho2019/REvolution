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
    reg [4:0] write_ptr;
    wire [4:0] read_ptr = write_ptr - 1;

    // Generate predict_history by reading circular buffer
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : history_read
            assign predict_history[i] = history_buffer[(read_ptr - i) % 32];
        end
    endgenerate

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_buffer <= 32'b0;
            write_ptr <= 5'b0;
        end else if (train_mispredicted) begin
            // Load history and append train_taken
            history_buffer <= train_history;
            history_buffer[0] <= train_taken;
            write_ptr <= 5'b1; // Point to next position
        end else if (predict_valid) begin
            // Write at current pointer and advance
            history_buffer[write_ptr] <= predict_taken;
            write_ptr <= write_ptr + 1;
        end
    end

endmodule