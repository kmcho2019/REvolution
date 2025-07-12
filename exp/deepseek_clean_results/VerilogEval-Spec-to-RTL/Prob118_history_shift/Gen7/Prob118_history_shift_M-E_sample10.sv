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
    reg [4:0] head_ptr;
    reg [4:0] base_ptr;  // For rollback tracking
    
    // Generate output by reading circular buffer
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : gen_predict_history
            assign predict_history[i] = history_buffer[(head_ptr + 1 + i) % 32];
        end
    endgenerate

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_buffer <= 32'b0;
            head_ptr <= 5'd0;
            base_ptr <= 5'd0;
        end else if (train_mispredicted) begin
            // Rollback operation
            history_buffer <= {train_history[30:0], train_taken};
            head_ptr <= 5'd31;  // Points to newest bit
            base_ptr <= 5'd31;
        end else if (predict_valid) begin
            // Circular update
            head_ptr <= head_ptr + 1;
            history_buffer[head_ptr] <= predict_taken;
        end
    end

endmodule