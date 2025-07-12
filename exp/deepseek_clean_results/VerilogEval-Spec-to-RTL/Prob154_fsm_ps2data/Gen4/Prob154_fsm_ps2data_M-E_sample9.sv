module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // 3-byte sliding window
    reg [7:0] byte_window [2:0];
    reg [1:0] valid_count;
    reg message_active;

    always @(posedge clk) begin
        if (reset) begin
            byte_window[0] <= 8'b0;
            byte_window[1] <= 8'b0;
            byte_window[2] <= 8'b0;
            valid_count <= 2'b0;
            message_active <= 1'b0;
            done <= 1'b0;
            out_bytes <= 24'bx;
        end else begin
            // Shift in new byte
            byte_window[0] <= byte_window[1];
            byte_window[1] <= byte_window[2];
            byte_window[2] <= in;

            // Detect message boundaries
            if (byte_window[1][3]) begin
                // Potential message start
                valid_count <= 2'b01;
                message_active <= 1'b1;
            end else if (message_active) begin
                // Count subsequent bytes
                if (valid_count < 2'b10)
                    valid_count <= valid_count + 1;
                else
                    message_active <= 1'b0;
            end

            // Output when we have complete message
            done <= (valid_count == 2'b10) && message_active;
            if ((valid_count == 2'b10) && message_active) begin
                out_bytes <= {byte_window[0], byte_window[1], byte_window[2]};
            end else begin
                out_bytes <= 24'bx;
            end
        end
    end

endmodule