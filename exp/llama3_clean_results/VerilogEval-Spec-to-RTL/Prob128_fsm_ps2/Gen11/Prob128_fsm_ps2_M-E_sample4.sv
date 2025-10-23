module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

logic [7:0] byte_buffer [2:0];
logic [1:0] byte_count;

always_ff @(posedge clk) begin
    if(reset) begin
        byte_count <= 2'b00;
        done <= 1'b0;
    end
    else begin
        // Shift incoming byte into the buffer
        byte_buffer[0] <= in;
        byte_buffer[1] <= byte_buffer[0];
        byte_buffer[2] <= byte_buffer[1];

        // Check if we've received the first byte of a message
        if(byte_count == 2'b00 && in[3]) begin
            byte_count <= 2'b01;
        end
        // Count the bytes
        else if(byte_count!= 2'b00 && byte_count < 2'b11) begin
            byte_count <= byte_count + 1'b1;
        end
        // Reset the counter if we've received three bytes or the first byte doesn't have in[3]=1
        else if(byte_count == 2'b11 || (byte_count == 2'b01 &&!byte_buffer[2][3])) begin
            byte_count <= 2'b00;
        end
    end
end

always_comb begin
    // Assert the 'done' signal when we've received three bytes
    if(byte_count == 2'b11) begin
        done = 1'b1;
    end
    else begin
        done = 1'b0;
    end
end

endmodule