module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot state encoding
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;

    reg [7:0] data_shift;
    reg [2:0] bit_index; // Counts 0 to 7 during RECEIVE

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            data_shift <= 8'b0;
            bit_index  <= 3'd0;
            done       <= 1'b0;
        end else begin
            done <= 1'b0; // Default done low

            state <= next_state;

            case (state)
                IDLE: begin
                    data_shift <= 8'b0;
                    bit_index  <= 3'd0;
                end
                RECEIVE: begin
                    // Shift left by one and insert new bit into LSB to maintain LSB-first
                    data_shift <= {in, data_shift[7:1]};
                    bit_index  <= bit_index + 1;
                end
                CHECK_STOP: begin
                    // No data shift or bit index update here
                end
                WAIT_STOP: begin
                    // Remain here until stop bit received
                    // No shift or bit index updates
                end
                default: begin
                    data_shift <= 8'b0;
                    bit_index  <= 3'd0;
                end
            endcase

            // done asserted only when stop bit correct at CHECK_STOP
            if (state == CHECK_STOP && in == 1'b1) begin
                done <= 1'b1;
            end
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;    // Start bit detected
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_index == 3'd7)
                    next_state = CHECK_STOP; // After 8 bits received
                else
                    next_state = RECEIVE;
            end
            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;       // Stop bit correct, ready for next byte
                else
                    next_state = WAIT_STOP;  // Stop bit incorrect, wait for stop bit
            end
            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;       // Stop bit found, resynchronize
                else
                    next_state = WAIT_STOP;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule