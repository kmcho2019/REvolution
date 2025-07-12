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
    reg [4:0] write_ptr;  // Points to current head position
    
    // Circular buffer implementation
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_buffer <= 32'b0;
            write_ptr <= 5'd0;
        end else begin
            if (train_mispredicted) begin
                // Calculate new pointer position based on train_history
                // train_history represents the state before misprediction
                // We need to write train_taken at the next position
                write_ptr <= train_history[31] + 5'd1;
                history_buffer[write_ptr] <= train_taken;
            end else if (predict_valid) begin
                write_ptr <= write_ptr + 5'd1;
                history_buffer[write_ptr] <= predict_taken;
            end
        end
    end

    // Generate output by reading from write_ptr+1 to write_ptr (32 bits)
    assign predict_history = {
        history_buffer[write_ptr[4:0]],
        history_buffer[write_ptr[4:0]-5'd1],
        history_buffer[write_ptr[4:0]-5'd2],
        history_buffer[write_ptr[4:0]-5'd3],
        history_buffer[write_ptr[4:0]-5'd4],
        history_buffer[write_ptr[4:0]-5'd5],
        history_buffer[write_ptr[4:0]-5'd6],
        history_buffer[write_ptr[4:0]-5'd7],
        history_buffer[write_ptr[4:0]-5'd8],
        history_buffer[write_ptr[4:0]-5'd9],
        history_buffer[write_ptr[4:0]-5'd10],
        history_buffer[write_ptr[4:0]-5'd11],
        history_buffer[write_ptr[4:0]-5'd12],
        history_buffer[write_ptr[4:0]-5'd13],
        history_buffer[write_ptr[4:0]-5'd14],
        history_buffer[write_ptr[4:0]-5'd15],
        history_buffer[write_ptr[4:0]-5'd16],
        history_buffer[write_ptr[4:0]-5'd17],
        history_buffer[write_ptr[4:0]-5'd18],
        history_buffer[write_ptr[4:0]-5'd19],
        history_buffer[write_ptr[4:0]-5'd20],
        history_buffer[write_ptr[4:0]-5'd21],
        history_buffer[write_ptr[4:0]-5'd22],
        history_buffer[write_ptr[4:0]-5'd23],
        history_buffer[write_ptr[4:0]-5'd24],
        history_buffer[write_ptr[4:0]-5'd25],
        history_buffer[write_ptr[4:0]-5'd26],
        history_buffer[write_ptr[4:0]-5'd27],
        history_buffer[write_ptr[4:0]-5'd28],
        history_buffer[write_ptr[4:0]-5'd29],
        history_buffer[write_ptr[4:0]-5'd30],
        history_buffer[write_ptr[4:0]-5'd31]
    };

endmodule