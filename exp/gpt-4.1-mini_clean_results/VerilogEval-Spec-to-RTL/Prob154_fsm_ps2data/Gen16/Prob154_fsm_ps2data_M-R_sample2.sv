module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] byte_count;    // Counts how many bytes collected: 0=no message started, 1=first byte, 2=second byte, 3=third byte
    reg start_detected;      // Flag indicating start byte found (in[3] == 1)

    // Detect if current byte qualifies as start byte
    wire start_byte = (in[3] == 1'b1);

    always @(posedge clk) begin
        if (reset) begin
            byte_count   <= 2'd0;
            out_bytes    <= 24'd0;
            done         <= 1'b0;
            start_detected <= 1'b0;
        end else begin
            done <= 1'b0; // Default done low

            if (byte_count == 0) begin
                // Waiting for start byte
                if (start_byte) begin
                    // Start message capture
                    start_detected <= 1'b1;
                    byte_count <= 2'd1;
                    // Place first byte in MSB of out_bytes
                    out_bytes <= {in, 16'd0};
                end else begin
                    start_detected <= 1'b0;
                    byte_count <= 2'd0;
                end
            end else if (byte_count == 1) begin
                // Capture second byte in middle byte of out_bytes
                out_bytes <= {out_bytes[23:16], in, 8'd0};
                byte_count <= 2'd2;
            end else if (byte_count == 2) begin
                // Capture third byte in LSB of out_bytes and assert done
                out_bytes <= {out_bytes[23:8], in};
                done <= 1'b1;
                byte_count <= 2'd0;
                start_detected <= 1'b0;
            end
        end
    end

endmodule