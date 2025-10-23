module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg done
);

    // Binary encoded FSM states
    localparam IDLE      = 2'b00;
    localparam RECEIVE   = 2'b01;
    localparam STOP_WAIT = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;   // 0 to 7
    reg [7:0] shift_reg;

    // FSM sequential logic
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Shift register and bit counter update
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'd0;
            bit_count <= 3'd0;
        end else if (state == RECEIVE) begin
            // Shift in LSB first
            shift_reg <= {in, shift_reg[7:1]};
            bit_count <= bit_count + 1'b1;
        end else if (state == IDLE) begin
            // Reset counters when idle
            shift_reg <= 8'd0;
            bit_count <= 3'd0;
        end
        // else hold values
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        done = 1'b0;
        case (state)
            IDLE: begin
                if (in == 1'b0)          // Detect start bit
                    next_state = RECEIVE;
            end
            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP_WAIT;
            end
            STOP_WAIT: begin
                if (in == 1'b1) begin     // Valid stop bit detected
                    done = 1'b1;
                    next_state = IDLE;
                end
                // else remain in STOP_WAIT waiting for stop bit
            end
        endcase
    end

endmodule