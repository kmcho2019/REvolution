module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Combined IDLE/ERROR state since both wait for start bit
    localparam WAITING = 1'b0;
    localparam RECEIVING = 1'b1;

    reg state, next_state;
    reg [3:0] bit_count;  // 4-bit counter with early termination
    reg [7:0] shift_reg;
    reg [7:0] captured_byte;
    reg stop_bit_valid;

    // State transition and data processing
    always @(posedge clk) begin
        if (reset) begin
            state <= WAITING;
            bit_count <= 0;
            shift_reg <= 0;
            captured_byte <= 0;
            out_byte <= 0;
            done <= 0;
            stop_bit_valid <= 0;
        end else begin
            state <= next_state;
            
            case (state)
                WAITING: begin
                    bit_count <= 0;
                    done <= 0;
                    if (in == 0) begin
                        shift_reg <= 0;  // Prepare for new reception
                    end
                end
                
                RECEIVING: begin
                    // Shift in new bit (LSB first)
                    shift_reg <= {in, shift_reg[7:1]};
                    
                    // Early stop bit detection when receiving last data bit
                    if (bit_count == 7) begin
                        stop_bit_valid <= in;  // Sample next bit (would be stop bit)
                        captured_byte <= {in, shift_reg[7:1]};  // Parallel capture
                    end
                    
                    bit_count <= bit_count + 1;
                end
            endcase
            
            // Output update only when valid stop bit is detected
            if (state == RECEIVING && bit_count == 8 && stop_bit_valid) begin
                out_byte <= captured_byte;
                done <= 1;
            end else begin
                done <= 0;
            end
        end
    end

    // Optimized next state logic
    always @(*) begin
        case (state)
            WAITING: 
                next_state = (in == 0) ? RECEIVING : WAITING;
            RECEIVING: 
                next_state = (bit_count == 8) ? WAITING : RECEIVING;
            default: 
                next_state = WAITING;
        endcase
    end

endmodule