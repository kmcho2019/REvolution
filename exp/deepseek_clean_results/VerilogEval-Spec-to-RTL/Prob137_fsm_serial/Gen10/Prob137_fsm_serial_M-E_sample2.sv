module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    reg [3:0] bit_counter;  // Counts 0-10 (start + 8 data + stop)
    reg [7:0] data_reg;
    reg active;  // Active reception flag

    // Combinational done signal - valid only when counter=10 and in=1
    assign done = (bit_counter == 4'd10) & in;

    always @(posedge clk) begin
        if (reset) begin
            bit_counter <= 4'd0;
            active <= 1'b0;
            data_reg <= 8'd0;
        end else begin
            // Idle detection
            if (!active && !in) begin
                active <= 1'b1;
                bit_counter <= 4'd1;  // Start counting at first data bit
            end
            // Active reception
            else if (active) begin
                if (bit_counter < 4'd9) begin
                    // Store data bits (LSB first)
                    data_reg[bit_counter-1] <= in;
                    bit_counter <= bit_counter + 1;
                end
                else if (bit_counter == 4'd9) begin
                    // Check stop bit
                    if (in) begin
                        bit_counter <= 4'd10;  // Mark completion
                    end
                    // Else stay at 9 waiting for stop bit
                end
                else if (bit_counter == 4'd10) begin
                    // Completion cycle
                    active <= 1'b0;
                    bit_counter <= 4'd0;
                end
            end
        end
    end

endmodule