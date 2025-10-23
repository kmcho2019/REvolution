module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    reg [9:0] frame_reg;  // [9:stop, 8:1:data, 0:start]
    reg [3:0] bit_count;

    always @(posedge clk) begin
        if (reset) begin
            frame_reg <= 10'b0;
            bit_count <= 0;
            out_byte <= 8'b0;
            done <= 0;
        end else begin
            done <= 0;

            if (bit_count == 0) begin
                // Idle state - waiting for start bit
                if (in == 0) begin
                    frame_reg <= {9'b0, in};  // Capture start bit
                    bit_count <= 1;
                end
            end else begin
                // Receiving state - shift in bits
                frame_reg <= {frame_reg[8:0], in};
                bit_count <= bit_count + 1;

                // Check for complete frame (10 bits)
                if (bit_count == 9) begin
                    if (frame_reg[9] == 1) begin  // Valid stop bit
                        out_byte <= frame_reg[8:1];  // Extract data bits
                        done <= 1;
                    end
                    bit_count <= 0;  // Return to idle
                end
            end
        end
    end

endmodule