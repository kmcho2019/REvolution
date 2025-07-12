module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg done
);

    // One-hot encoded FSM states
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;

    reg [2:0] bit_count;     // Counts data bits received: 0 to 7
    reg [7:0] shift_reg;     // Shift register for 8 data bits

    // Clock enable for shift_reg and bit_count updates
    wire clk_en = (state == RECEIVE);

    // Sequential logic: FSM state update
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Sequential logic: shift register and bit counter update only when clk_en is asserted
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'd0;
            bit_count <= 3'd0;
        end else if (clk_en) begin
            // Shift left with in as LSB (LSB first)
            shift_reg <= {in, shift_reg[7:1]};
            bit_count <= bit_count + 1'b1;
        end else if (state == IDLE) begin
            // Reset counters when idle
            shift_reg <= 8'd0;
            bit_count <= 3'd0;
        end
        // Otherwise hold values
    end

    // Combinational logic: Next state logic
    always @(*) begin
        next_state = state; // Default hold state
        case (state)
            IDLE: begin
                if (in == 1'b0)       // Detect start bit
                    next_state = RECEIVE;
            end
            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
            end
            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;      // Correct stop bit, ready for next byte
                else
                    next_state = WAIT_STOP; // Invalid stop bit, wait for stop bit to appear
            end
            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;      // Stop bit detected, go idle for next byte
            end
        endcase
    end

    // Separate always block for done signal (one cycle pulse when stop bit correct)
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
        end else if (state == CHECK_STOP && in == 1'b1) begin
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
    end

endmodule