module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    reg state;  // 0: IDLE, 1: ACTIVE
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            bit_count <= 0;
            shift_reg <= 0;
            done <= 0;
        end else begin
            done <= 0;  // Default value
            
            if (state == 0) begin  // IDLE
                if (in == 0) begin  // Start bit detected
                    state <= 1;
                    bit_count <= 0;
                    shift_reg <= 0;
                end
            end else begin  // ACTIVE
                if (bit_count < 8) begin  // Receiving data bits
                    shift_reg <= {in, shift_reg[7:1]};  // LSB first
                    bit_count <= bit_count + 1;
                end else begin  // Checking stop bit
                    if (in == 1) begin  // Valid stop bit
                        done <= 1;
                        state <= 0;
                    end
                    // Stay in ACTIVE state if stop bit is missing
                end
            end
        end
    end

endmodule