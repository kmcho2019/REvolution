module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [7:0] byte_buffer [0:2];  // 3-byte shift register
    reg [1:0] byte_count;         // Tracks how many bytes in current message
    reg searching;                // 1 when searching for start of message

    // Shift register and control logic
    always @(posedge clk) begin
        if (reset) begin
            byte_buffer[0] <= 8'b0;
            byte_buffer[1] <= 8'b0;
            byte_buffer[2] <= 8'b0;
            byte_count <= 2'b0;
            searching <= 1'b1;
        end else begin
            // Shift in new byte
            byte_buffer[0] <= byte_buffer[1];
            byte_buffer[1] <= byte_buffer[2];
            byte_buffer[2] <= in;

            // Control logic
            if (searching) begin
                if (in[3]) begin
                    searching <= 1'b0;
                    byte_count <= 2'b01;
                end
            end else begin
                if (byte_count == 2'b10) begin
                    searching <= 1'b1;
                    byte_count <= 2'b0;
                end else begin
                    byte_count <= byte_count + 1'b1;
                end
            end
        end
    end

    // Done is high when we've received 3 bytes in a message
    assign done = (~searching) & (byte_count == 2'b10);

endmodule