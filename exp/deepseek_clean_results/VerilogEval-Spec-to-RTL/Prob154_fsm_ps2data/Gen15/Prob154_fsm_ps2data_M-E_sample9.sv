module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] byte_counter;  // Counts 0-2 (3 bytes)
    reg capturing;           // Flag indicating we're in message capture mode

    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b00;
            capturing <= 1'b0;
            out_bytes <= 24'bx;
            done <= 1'b0;
        end else begin
            done <= 1'b0;  // Default to not done

            if (capturing) begin
                // Shift in new byte
                out_bytes <= {out_bytes[15:0], in};
                
                if (byte_counter == 2'b10) begin
                    // Third byte received
                    done <= 1'b1;
                    capturing <= 1'b0;
                    byte_counter <= 2'b00;
                end else begin
                    byte_counter <= byte_counter + 1'b1;
                end
            end else if (in[3]) begin
                // Start new message capture
                capturing <= 1'b1;
                byte_counter <= 2'b00;
                out_bytes <= {16'b0, in};  // Initialize with first byte
            end
        end
    end

endmodule