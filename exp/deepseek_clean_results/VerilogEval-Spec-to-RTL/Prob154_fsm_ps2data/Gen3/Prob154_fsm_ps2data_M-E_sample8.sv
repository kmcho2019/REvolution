module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // Triple buffer storage
    reg [23:0] msg_buffer [0:2];
    reg [1:0] buf_ptr;
    reg [1:0] byte_count [0:2];
    reg [1:0] active_buf;
    reg [1:0] ready_buf;

    always @(posedge clk) begin
        if (reset) begin
            // Clear all buffers and counters
            for (integer i = 0; i < 3; i = i + 1) begin
                msg_buffer[i] <= 24'b0;
                byte_count[i] <= 2'b0;
            end
            buf_ptr <= 2'b0;
            active_buf <= 2'b0;
            ready_buf <= 2'b0;
            done <= 1'b0;
            out_bytes <= 24'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            
            // Check for valid start byte in all buffers
            if (in[3]) begin
                // Rotate to next buffer
                buf_ptr <= (buf_ptr == 2'b10) ? 2'b00 : buf_ptr + 1;
                // Initialize new buffer
                msg_buffer[buf_ptr] <= {in, 16'b0};
                byte_count[buf_ptr] <= 2'b01;
                active_buf <= buf_ptr;
            end else if (byte_count[active_buf] != 2'b0) begin
                // Shift into active buffer
                case (byte_count[active_buf])
                    2'b01: begin
                        msg_buffer[active_buf][15:8] <= in;
                        byte_count[active_buf] <= 2'b10;
                    end
                    2'b10: begin
                        msg_buffer[active_buf][7:0] <= in;
                        byte_count[active_buf] <= 2'b00;
                        ready_buf <= active_buf;
                        done <= 1'b1;
                        out_bytes <= msg_buffer[active_buf];
                    end
                    default: ; // Do nothing
                endcase
            end
        end
    end

endmodule