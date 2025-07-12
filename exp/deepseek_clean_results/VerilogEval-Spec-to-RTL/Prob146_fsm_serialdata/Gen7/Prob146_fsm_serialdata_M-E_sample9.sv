module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Combined state and data register
    reg [9:0] shift_reg;  // [9]: state (1=idle, 0=receiving), [8:1]: data, [0]: start bit

    // Protocol constants
    localparam IDLE = 1'b1;
    localparam RECEIVING = 1'b0;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= {10{1'b1}};  // All 1's means idle
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            
            // Shift in new bit
            shift_reg <= {shift_reg[8:0], in};
            
            // Check protocol conditions in parallel
            if (shift_reg[9]) begin  // IDLE state
                if (!in) begin  // Start bit detected
                    shift_reg[9] <= RECEIVING;
                end
            end else begin  // RECEIVING state
                // Check if we've received all 8 data bits + start bit
                if (&shift_reg[8:1]) begin  // All bits shifted in
                    if (in) begin  // Valid stop bit
                        out_byte <= shift_reg[8:1];
                        done <= 1'b1;
                        shift_reg[9] <= IDLE;
                    end
                    // If stop bit invalid, stay in receiving state until we see 1
                end
            end
        end
    end

endmodule