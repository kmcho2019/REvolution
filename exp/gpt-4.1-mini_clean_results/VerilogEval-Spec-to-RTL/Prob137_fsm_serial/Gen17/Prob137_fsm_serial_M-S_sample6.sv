module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    reg [3:0] bit_pos; // Counts bits: 0=start, 1-8=data, 9=stop
    reg receiving;     // High during byte reception

    always @(posedge clk) begin
        if (reset) begin
            bit_pos   <= 4'd0;
            receiving <= 1'b0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0; // Default no done

            if (!receiving) begin
                // Waiting for start bit (0) on idle line (1)
                if (in == 1'b0) begin
                    receiving <= 1'b1;
                    bit_pos   <= 4'd1; // start bit detected, move to data bits
                end
            end else begin
                // Receiving bits
                if (bit_pos <= 4'd8) begin
                    // Data bits: just count through
                    bit_pos <= bit_pos + 1'b1;
                end else if (bit_pos == 4'd9) begin
                    // Stop bit check
                    if (in == 1'b1) begin
                        // Valid stop bit, done pulse and return to idle
                        done      <= 1'b1;
                        receiving <= 1'b0;
                        bit_pos   <= 4'd0;
                    end else begin
                        // Invalid stop bit, wait here until in==1 (stop bit)
                        // Stay in bit_pos 9 and receiving
                        // No done pulse until stop bit detected
                    end
                end
            end
        end
    end

endmodule