module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // FSM state encoding
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam CHECK_STOP = 2'd2;
    localparam WAIT_STOP  = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)       // Start bit detected
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7) // 8 data bits received
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                if (in == 1'b1)       // Valid stop bit
                    next_state = IDLE;
                else                  // Framing error
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                if (in == 1'b1)       // Wait until line is idle (stop bit)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, counters, shift register, done pulse
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // default done deasserted

            // Clear counters and shift register only on IDLE and WAIT_STOP to reduce switching
            if ((next_state == IDLE) || (next_state == WAIT_STOP)) begin
                bit_count <= 3'd0;
                shift_reg <= 8'd0;
            end else if (state == RECEIVE) begin
                // Shift right with LSB-first insertion: new bit is MSB in concatenation to shift_reg[7:1]
                shift_reg <= {in, shift_reg[7:1]};
                bit_count <= bit_count + 1'b1;
            end

            if (state == CHECK_STOP) begin
                if (in == 1'b1) begin
                    done <= 1'b1;  // valid stop bit: pulse done high one cycle
                end
                // bit_count and shift_reg cleared on state move out to IDLE or WAIT_STOP
            end
        end
    end

endmodule