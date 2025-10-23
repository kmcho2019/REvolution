module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    reg [7:0] shift_reg;
    reg [3:0] bit_counter;  // Counts 0-9 (start + 8 data + stop)
    reg receiving;

    // Protocol detection
    wire start_bit = (bit_counter == 0) & ~in & ~reset;
    wire byte_done = (bit_counter == 9);
    wire valid_stop = byte_done & in;

    // Done signal (combinatorial)
    assign done = valid_stop;

    // Data output register
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'b0;
            shift_reg <= 8'b0;
            bit_counter <= 4'b0;
            receiving <= 1'b0;
        end else begin
            if (start_bit) begin
                receiving <= 1'b1;
                bit_counter <= 4'd1;
            end 
            else if (receiving) begin
                if (bit_counter < 9) begin
                    // Shift in data (LSB first)
                    if (bit_counter < 9) begin
                        shift_reg <= {in, shift_reg[7:1]};
                    end
                    bit_counter <= bit_counter + 1;
                end
                else if (valid_stop) begin
                    out_byte <= shift_reg;
                    receiving <= 1'b0;
                    bit_counter <= 4'b0;
                end
                // Else stay in receiving state until stop bit
            end
        end
    end

endmodule