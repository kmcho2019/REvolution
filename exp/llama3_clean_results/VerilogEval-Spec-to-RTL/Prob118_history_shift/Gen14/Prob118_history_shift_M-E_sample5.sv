module TopModule(
    input           clk,
    input           areset,
    input           predict_valid,
    input           predict_taken,
    input           train_mispredicted,
    input           train_taken,
    input   [31:0]   train_history,
    output  [31:0]   predict_history
);

reg [31:0] history_buffer [31:0];
reg [4:0] read_ptr;
reg [4:0] write_ptr;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        read_ptr <= 5'd0;
        write_ptr <= 5'd0;
        for (int i = 0; i < 32; i++) begin
            history_buffer[i] <= 1'b0;
        end
    end else if (predict_valid) begin
        history_buffer[write_ptr] <= predict_taken;
        write_ptr <= (write_ptr + 1) % 32;
    end else if (train_mispredicted) begin
        for (int i = 0; i < 31; i++) begin
            history_buffer[(write_ptr + i) % 32] <= train_history[i];
        end
        history_buffer[(write_ptr + 31) % 32] <= train_taken;
        write_ptr <= (write_ptr + 32) % 32;
    end
end

always @(*) begin
    predict_history = 32'd0;
    for (int i = 0; i < 32; i++) begin
        predict_history[i] = history_buffer[(read_ptr + i) % 32];
    end
end

endmodule