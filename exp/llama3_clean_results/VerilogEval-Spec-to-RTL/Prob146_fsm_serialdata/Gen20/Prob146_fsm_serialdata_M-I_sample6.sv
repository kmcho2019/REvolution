module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [3:0] state; // Added more states for clearer transitions
reg [2:0] bit_pos;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // IDLE
        bit_pos <= 0;
        done <= 0;
        out_byte <= 8'b0;
    end
    else begin
        case(state)
            0: begin // IDLE
                if (!in) begin // Wait for start bit
                    state <= 1; // START
                    bit_pos <= 0;
                end
            end
            1: begin // START
                state <= 2; // DATA
            end
            2: begin // DATA
                out_byte[bit_pos] <= in; // Update out_byte in the correct order
                bit_pos <= bit_pos + 1;
                if (bit_pos == 8) begin
                    state <= 3; // STOP
                end
            end
            3: begin // STOP
                if (in) begin // Correct stop bit detected
                    done <= 1;
                    state <= 0; // IDLE
                    bit_pos <= 0;
                end
                else begin
                    state <= 4; // WAIT_STOP
                end
            end
            4: begin // WAIT_STOP
                if (in) begin // Stop bit detected, proceed to IDLE
                    state <= 0; // IDLE
                end
                // Else, stay in WAIT_STOP until stop bit is detected
            end
        endcase
        if (state != 3) begin
            done <= 0;
        end
    end
end

endmodule