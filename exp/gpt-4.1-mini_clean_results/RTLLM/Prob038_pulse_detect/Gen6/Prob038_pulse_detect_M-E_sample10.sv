module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg [1:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            shift_reg <= 2'b00;
            data_out <= 1'b0;
        end else begin
            // Shift in the current data_in
            shift_reg <= {shift_reg[0], data_in};

            // Detect pulse: previously was '1' then now '0'
            // Pulse pattern: data_in sequence 0->1->0
            // So shift_reg before shift_in = bits from two previous cycles,
            // current data_in is new input.
            // If shift_reg == 2'b10 (previous two cycles: '1' then '0') and data_in == 0,
            // it means previous was '1', last was '0', now '0' -> pulse detected at current cycle.
            // But note the problem's example: pulse is 0->1->0 in three cycles.
            // Actually, shift_reg holds last two samples: the bit from two cycles ago and one cycle ago.
            // So the sequence "0 -> 1 -> 0" over three cycles corresponds to:
            // shift_reg = {bit_t-2, bit_t-1} = "01" when bit_t = 0 (current input)
            // So correct condition is shift_reg == 2'b01 && data_in == 0.

            if (shift_reg == 2'b01 && data_in == 1'b0)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule