module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // States - 2-bit one-hot encoding for better timing
    localparam IDLE    = 2'b01;
    localparam RECEIVE = 2'b10;
    localparam DONE    = 2'b11;

    reg [1:0] state, next_state;
    reg [8:0] frame_reg;  // Stores start bit + 8 data bits + stop bit

    // State transition and data processing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            frame_reg <= 9'b1_1111_1111;  // Initialize to idle state (all 1's)
            out_byte <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    done <= 0;
                    if (in == 0) begin
                        frame_reg <= {8'b1111_1111, 1'b0};  // Initialize with start bit
                    end
                end
                
                RECEIVE: begin
                    frame_reg <= {in, frame_reg[8:1]};  // Shift in new bit
                    
                    // Check for complete frame (bit 8 is stop bit)
                    if (frame_reg[8] == 1'b0 && in == 1'b1) begin
                        out_byte <= frame_reg[7:0];  // Parallel load of data bits
                    end
                end
                
                DONE: begin
                    done <= 1'b1;
                end
            endcase
        end
    end

    // Next state logic - optimized with early detection
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in == 0) ? RECEIVE : IDLE;
            end
            
            RECEIVE: begin
                // Transition to DONE if we've seen start bit (0) followed by stop bit (1)
                // or stay in RECEIVE otherwise (including error cases)
                next_state = (frame_reg[8] == 1'b0 && in == 1'b1) ? DONE : RECEIVE;
            end
            
            DONE: begin
                next_state = IDLE;
            end
            
            default: next_state = IDLE;
        endcase
    end

endmodule