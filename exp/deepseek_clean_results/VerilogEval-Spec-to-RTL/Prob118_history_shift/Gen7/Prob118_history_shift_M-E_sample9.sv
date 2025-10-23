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
    wire [31:0] rotated_history;

    // Circular buffer rotation logic
    assign rotated_history = {history_buffer[write_ptr:0], history_buffer[31:write_ptr+1]};

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_buffer <= 32'b0;
            write_ptr <= 5'b0;
        end else if (train_mispredicted) begin
            // On misprediction, load history and append actual result
            history_buffer <= {train_history[30:0], train_taken};
            write_ptr <= 5'd31; // Point to the newly written bit
        end else if (predict_valid) begin
            // Normal prediction: circular write
            write_ptr <= write_ptr + 1;
            history_buffer[write_ptr] <= predict_taken;
        end
    end

    // Output is the rotated view of the buffer
    assign predict_history = rotated_history;

endmodule