module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);
    // State encoding
    typedef enum reg [2:0] {
        IDLE = 3'd0,
        START = 3'd1,
        DATA = 3'd2,
        STOP = 3'd3,
        WAIT_STOP = 3'd4
    } state_t;
    
    state_t state, next_state;
    reg [2:0] bit_count;       // To count data bits (0 to 7)
    reg [7:0] data_shift;      // To shift in data bits (LSB first)

    // Sequential block: state transition, bit_count, data shift, outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done low, set high only when valid stop bit
            
            case(state)
                IDLE: begin
                    // No counters or shifts needed here
                    bit_count <= 3'd0;
                    data_shift <= 8'd0;
                end
                START: begin
                    // No shifting, just move to DATA
                    bit_count <= 3'd0;
                    data_shift <= 8'd0;
                end
                DATA: begin
                    // Shift in data bit LSB first
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 3'd1;
                end
                STOP: begin
                    // When stop bit is detected, latch data and assert done
                    if(in == 1'b1) begin
                        out_byte <= data_shift;
                        done <= 1'b1;
                    end
                end
                WAIT_STOP: begin
                    // Wait for stop bit '1' to return to IDLE
                end
            endcase
        end
    end

    // Combinational block: next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if(in == 1'b0) 
                    next_state = START; // detected start bit
            end
            START: begin
                next_state = DATA; // start collecting data bits on next clock
            end
            DATA: begin
                if(bit_count == 3'd7)
                    next_state = STOP; // after last data bit received
                else
                    next_state = DATA; // continue shifting in data bits
            end
            STOP: begin
                if(in == 1'b1)
                    next_state = IDLE; // valid stop bit, done received
                else
                    next_state = WAIT_STOP; // invalid stop bit, wait for stop bit before continuing
            end
            WAIT_STOP: begin
                if(in == 1'b1)
                    next_state = IDLE; // stop bit detected, resume idle
            end
            default: next_state = IDLE;
        endcase
    end
endmodule