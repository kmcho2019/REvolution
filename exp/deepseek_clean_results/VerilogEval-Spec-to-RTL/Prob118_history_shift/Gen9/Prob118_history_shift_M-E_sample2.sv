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
    reg [4:0] head_ptr;  // Points to current insertion position
    reg [4:0] wrap_count; // Tracks how many times we've wrapped around

    // Circular buffer output generation
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : history_output
            assign predict_history[i] = history_buffer[(head_ptr + i + 1) % 32];
        end
    endgenerate

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_buffer <= 32'b0;
            head_ptr <= 5'd31;  // Start at end to match shift behavior
            wrap_count <= 5'd0;
        end
        else if (train_mispredicted) begin
            // Direct load with train_history + train_taken
            history_buffer <= {train_history[30:0], train_taken};
            head_ptr <= 5'd31;
            wrap_count <= 5'd0;
        end
        else if (predict_valid) begin
            // Circular update - overwrite oldest entry when full
            history_buffer[head_ptr] <= predict_taken;
            head_ptr <= (head_ptr == 0) ? 5'd31 : head_ptr - 1;
            if (head_ptr == 0) wrap_count <= wrap_count + 1;
        end
    end

endmodule