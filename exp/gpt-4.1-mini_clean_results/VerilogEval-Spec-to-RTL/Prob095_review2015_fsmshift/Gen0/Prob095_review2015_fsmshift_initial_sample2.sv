module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    reg [1:0] ena_count;    // counts down 4 cycles when enabled
    reg [2:0] pattern_shift; // 3-bit shift register to detect pattern

    wire pattern_detected = (pattern_shift == 3'b111);

    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b1;
            ena_count <= 2'd3;  // count of remaining cycles after this clock
            pattern_shift <= 3'b000;
        end else begin
            // Shift the pattern register, sample current shift_ena to detect pattern 
            pattern_shift <= {pattern_shift[1:0], shift_ena};

            // If shift enable active, count down
            if (shift_ena) begin
                if (ena_count != 0) begin
                    ena_count <= ena_count - 1;
                    shift_ena <= 1'b1;
                end else begin
                    shift_ena <= 1'b0;
                end
            end else if (pattern_detected) begin
                // Start 4-cycle shift_ena on pattern detect
                shift_ena <= 1'b1;
                ena_count <= 2'd3;
            end else begin
                shift_ena <= 1'b0;
            end
        end
    end

endmodule