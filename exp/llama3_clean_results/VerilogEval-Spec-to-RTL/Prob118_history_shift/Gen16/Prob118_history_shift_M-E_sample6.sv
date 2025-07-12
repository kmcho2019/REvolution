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

reg [31:0] buffer;
reg [4:0] pointer;
reg [31:0] trained_history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        buffer <= 32'd0;
        pointer <= 5'd0;
        trained_history <= 32'd0;
    end else begin
        if (train_mispredicted) begin
            // Load the trained history into the buffer
            buffer <= {trained_history, train_taken};
            pointer <= 5'd0;
            trained_history <= train_history;
        end else if (predict_valid) begin
            // Update the buffer at the current position with the predicted taken value
            buffer[pointer] <= predict_taken;
            // Move the pointer to the next position
            pointer <= (pointer + 1) % 32;
        end 
    end
end

assign predict_history = buffer;

endmodule