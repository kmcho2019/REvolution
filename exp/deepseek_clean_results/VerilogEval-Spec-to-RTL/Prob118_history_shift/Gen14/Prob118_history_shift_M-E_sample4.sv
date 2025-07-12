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
    reg [4:0] head_ptr;  // Points to current write position (0-31)
    wire [4:0] next_ptr = head_ptr + 1;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_buffer <= 32'b0;
            head_ptr <= 5'b0;
        end else if (train_mispredicted) begin
            // On misprediction: load corrected history and reset pointer
            history_buffer <= {train_history[30:0], train_taken};
            head_ptr <= 5'd31;  // Point to newly written bit
        end else if (predict_valid) begin
            // On prediction: update current position and advance pointer
            history_buffer[head_ptr] <= predict_taken;
            head_ptr <= next_ptr;
        end
    end

    // Circular rotation for output - reconstruct linear history
    assign predict_history = {history_buffer[head_ptr:0], 
                            history_buffer[31:head_ptr+1]};

endmodule