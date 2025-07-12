module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    reg [8:0] shift_reg; // 9-bit: 1 state bit + 8 data bits
    reg [3:0] bit_count; // Counts 0-8 (9 cycles total)
    reg last_in;         // For edge detection

    // Edge detection
    wire start_edge = (last_in == 1'b1) && (in == 1'b0);

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 9'b1_00000000; // MSB=1 means idle
            bit_count <= 4'd0;
            out_byte <= 8'b0;
            done <= 1'b0;
            last_in <= 1'b1;
        end else begin
            last_in <= in;
            done <= 1'b0; // Default: done is low

            // Shift register operation
            if (shift_reg[8] == 1'b0) begin // Receiving mode
                shift_reg <= {in, shift_reg[7:0]};
                bit_count <= bit_count + 1;
                
                // After 9 bits (start + 8 data), check stop bit
                if (bit_count == 4'd8) begin
                    if (in == 1'b1) begin // Valid stop bit
                        out_byte <= shift_reg[7:0];
                        done <= 1'b1;
                    end
                    shift_reg[8] <= 1'b1; // Return to idle
                    bit_count <= 4'd0;
                end
            end
            else if (start_edge) begin // Start bit detected
                shift_reg[8] <= 1'b0;  // Enter receiving mode
                bit_count <= 4'd0;
            end
        end
    end

endmodule