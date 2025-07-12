module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Define states
    typedef enum logic [1:0] {
        IDLE,
        RECEIVE,
        CHECK_STOP
    } state_t;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            state <= next_state;
            done <= 0;  // Default done to 0
            
            case (state)
                IDLE: begin
                    bit_count <= 0;
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // Shift right (LSB first)
                    bit_count <= bit_count + 1;
                end
                
                CHECK_STOP: begin
                    if (in == 1) begin  // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        
        case (state)
            IDLE: begin
                if (in == 0)  // Start bit detected
                    next_state = RECEIVE;
            end
            
            RECEIVE: begin
                if (bit_count == 7)  // Received all 8 bits
                    next_state = CHECK_STOP;
            end
            
            CHECK_STOP: begin
                if (in == 1)  // Valid stop bit
                    next_state = IDLE;
                // Else stay in CHECK_STOP until we find stop bit
            end
        endcase
    end

endmodule