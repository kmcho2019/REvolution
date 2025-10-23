module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot encoded FSM states (4 bits, one bit per state)
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Combinational next_state logic with one-hot FSM
    wire start_bit_detected = (in == 1'b0);
    wire stop_bit_detected  = (in == 1'b1);

    assign next_state = 
        (state == IDLE)       ? (start_bit_detected ? RECEIVE    : IDLE) :
        (state == RECEIVE)    ? ((bit_count == 3'd7) ? CHECK_STOP : RECEIVE) :
        (state == CHECK_STOP) ? (stop_bit_detected ? IDLE : WAIT_STOP) :
        (state == WAIT_STOP)  ? (stop_bit_detected ? IDLE : WAIT_STOP) :
                               IDLE;

    // Combinational done generation (one cycle pulse)
    wire done_next = (state == CHECK_STOP) && stop_bit_detected;

    // Sequential logic: state, bit_count, shift_reg, done
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low, asserted one cycle on valid stop bit
            done <= done_next;

            // Bit counter logic
            if (state == IDLE) begin
                bit_count <= 3'd0;
                shift_reg <= 8'd0;
            end else if (state == RECEIVE) begin
                bit_count <= bit_count + 1'b1;
                // Shift right by 1, insert new bit at MSB (LSB first serial input)
                shift_reg <= {in, shift_reg[7:1]};
            end else if (state == CHECK_STOP || state == WAIT_STOP) begin
                bit_count <= 3'd0;
                if (state == WAIT_STOP)
                    shift_reg <= 8'd0;  // Clear shift register while waiting for valid stop bit
            end
        end
    end

endmodule