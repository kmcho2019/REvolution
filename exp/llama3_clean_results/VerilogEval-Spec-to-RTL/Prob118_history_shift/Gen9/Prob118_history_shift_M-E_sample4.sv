module TopModule (
    input           clk,
    input           areset,
    input           predict_valid,
    input           predict_taken,
    input           train_mispredicted,
    input           train_taken,
    input   [31:0]   train_history,
    output  [31:0]   predict_history
);

reg [31:0] history_buffer;
reg [31:0] update_buffer;
reg         update_valid;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history_buffer <= 32'd0;
        update_buffer <= 32'd0;
        update_valid <= 1'b0;
    end else begin
        if (train_mispredicted) begin
            update_buffer <= {train_history, train_taken};
            update_valid <= 1'b1;
        end else if (predict_valid) begin
            update_buffer <= {history_buffer[30:0], predict_taken};
            update_valid <= 1'b1;
        end else begin
            update_valid <= 1'b0;
        end
        
        if (update_valid) begin
            history_buffer <= update_buffer;
        end
    end
end

assign predict_history = history_buffer;

endmodule