module TopModule (
    input         clk,
    input         rst_n,
    input         start,        // Signal to start reversing
    input  [99:0] in,
    output reg [99:0] out,
    output reg    valid         // Goes high for one cycle when output is ready
);

    reg [6:0] bit_index;        // Enough bits to count to 100 (max 127)
    reg [99:0] shift_reg;
    reg        busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_index <= 0;
            shift_reg <= 100'b0;
            out       <= 100'b0;
            valid     <= 0;
            busy      <= 0;
        end else begin
            valid <= 0;  // default, clear valid each cycle

            if (start && !busy) begin
                // Start the bit reversal process
                busy <= 1;
                bit_index <= 0;
                shift_reg <= 100'b0;
            end else if (busy) begin
                // Shift in bits from input LSB upwards
                shift_reg <= {in[bit_index], shift_reg[99:1]}; // Shift left by 1, insert new bit at MSB position

                bit_index <= bit_index + 1;

                if (bit_index == 99) begin
                    // Completed shifting all bits
                    out   <= shift_reg;
                    valid <= 1;
                    busy  <= 0;
                end
            end
        end
    end

endmodule