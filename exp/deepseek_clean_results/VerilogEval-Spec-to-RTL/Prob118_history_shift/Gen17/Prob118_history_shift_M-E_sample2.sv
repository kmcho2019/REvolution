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
    reg [4:0] write_ptr;  // Points to next write location (0-31)
    wire [4:0] next_ptr = write_ptr + 1;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_buffer <= 32'b0;
            write_ptr <= 5'b0;
        end else if (train_mispredicted) begin
            // On misprediction, load history and append actual taken
            history_buffer <= {train_history[30:0], train_taken};
            write_ptr <= 5'd31;  // Next write will be at position 0
        end else if (predict_valid) begin
            // Circular write - overwrite oldest entry
            history_buffer[write_ptr] <= predict_taken;
            write_ptr <= next_ptr;
        end
    end

    // Circular read - reconstruct the correct order
    assign predict_history = {
        history_buffer[write_ptr[4:0]],
        history_buffer[{write_ptr[3:0],1'b0}+:16],
        history_buffer[{write_ptr[3:0],1'b1}+:16]
    };

endmodule