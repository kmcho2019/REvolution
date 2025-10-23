module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    reg [3:0] counter;  // Counts 0-10 (11 bits total)
    reg [7:0] data_reg;
    wire counter_max = (counter == 4'd10);
    wire data_valid = (counter == 4'd9) & in;  // Stop bit check at pos 10

    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'd0;
            data_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;

            if (counter == 4'd0) begin
                // Start bit detection
                if (~in) begin
                    counter <= counter + 1;
                    data_reg <= 8'd0;  // Clear on start bit
                end
            end else if (~counter_max) begin
                // Data collection (positions 1-8)
                if (counter <= 4'd8) begin
                    data_reg <= {in, data_reg[7:1]};  // LSB first
                end
                counter <= counter + 1;
            end else begin
                // Stop bit validation (position 10)
                if (in) begin
                    out_byte <= data_reg;
                    done <= 1'b1;
                end
                counter <= 4'd0;  // Reset regardless of stop bit validity
            end
        end
    end

endmodule