module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    reg [3:0] counter;  // Counts 0-9 (start + 8 data + stop)
    reg [7:0] shift_reg;
    reg active;

    // Combinatorial done signal
    assign done = (counter == 4'd9) && in;  // Valid stop bit

    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            active <= 0;
            shift_reg <= 0;
            out_byte <= 0;
        end else begin
            if (!active) begin
                // IDLE state
                if (!in) begin  // Start bit detected
                    active <= 1;
                    counter <= 1;  // Skip start bit position
                    shift_reg <= 0;
                end
            end else begin
                // ACTIVE state
                if (counter < 9) begin
                    if (counter < 8) begin
                        // Shift in data bits (LSB first)
                        shift_reg <= {in, shift_reg[7:1]};
                    end
                    counter <= counter + 1;
                end else begin
                    // Counter = 9 (stop bit position)
                    if (in) begin
                        // Valid stop bit - load output and return to IDLE
                        out_byte <= shift_reg;
                        active <= 0;
                        counter <= 0;
                    end
                    // Else: counter remains at 9 until line goes high
                end
            end
        end
    end

endmodule