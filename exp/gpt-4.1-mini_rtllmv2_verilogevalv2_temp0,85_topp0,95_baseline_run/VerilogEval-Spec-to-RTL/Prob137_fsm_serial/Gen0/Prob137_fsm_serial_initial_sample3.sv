module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // States
    typedef enum reg [1:0] {
        IDLE      = 2'd0,
        DATA      = 2'd1,
        STOP      = 2'd2,
        WAIT_STOP = 2'd3
    } state_t;

    state_t state, next_state;
    reg [3:0] bit_count; // up to 8 bits
    reg [7:0] data_shift; // store received data bits (not used for output)
    
    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_shift <= 8'd0;
            done <= 0;
        end else begin
            state <= next_state;
            done <= 0; // default done low each cycle
            
            case (state)
                IDLE: begin
                    bit_count <= 0;
                    data_shift <= 8'd0;
                    if (in == 1'b0) begin
                        // detected start bit
                        bit_count <= 0;
                    end
                end
                DATA: begin
                    // shift in data bits LSB first
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    // do nothing special here
                end
                WAIT_STOP: begin
                    // waiting for stop bit == 1, do nothing else
                end
            endcase
        end
    end
    
    // Next state logic and done signal
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = DATA;
            end
            DATA: begin
                if (bit_count == 7) // last data bit received at next clock
                    next_state = STOP;
            end
            STOP: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                    // assert done on next clock (done assigned in sequential always)
                end else begin
                    next_state = WAIT_STOP;
                end
            end
            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
            end
        endcase
    end

    // done signal asserted synchronously when in STOP state and stop bit correct
    always @(posedge clk) begin
        if (!reset) begin
            if (state == STOP && in == 1'b1)
                done <= 1'b1;
            else
                done <= 1'b0;
        end
    end

endmodule