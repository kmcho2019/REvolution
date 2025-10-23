module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    reg [7:0] shift_reg;
    reg [3:0] bit_counter;  // Counts 0-8 (need 4 bits)
    reg reception_active;
    reg valid_stop;

    // Shift register and counter logic
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'b0;
            bit_counter <= 4'b0;
            reception_active <= 1'b0;
            valid_stop <= 1'b0;
        end else begin
            if (!reception_active) begin
                // Idle state - wait for start bit
                if (in == 1'b0) begin
                    reception_active <= 1'b1;
                    bit_counter <= 4'b0;
                    shift_reg <= 8'b0;
                end
            end else begin
                // Reception active - process bits
                if (bit_counter < 8) begin
                    // Shift in data bits (LSB first)
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_counter <= bit_counter + 1;
                end else begin
                    // Check stop bit
                    valid_stop <= in;
                    reception_active <= !in;  // Deactivate if stop bit valid
                    bit_counter <= 4'b0;       // Reset counter
                end
            end
        end
    end

    // Output assignment
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'b0;
        end else if (bit_counter == 8 && in) begin
            out_byte <= shift_reg;
        end
    end

    // Done signal is combinatorial
    assign done = (bit_counter == 8) && in && reception_active;

endmodule