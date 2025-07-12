module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // Binary encoded FSM states
    localparam IDLE       = 3'd0;
    localparam RECEIVE    = 3'd1;
    localparam CHECK_STOP = 3'd2;
    localparam WAIT_STOP  = 3'd3;

    reg [2:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low; pulse done only in CHECK_STOP state with valid stop bit
            done <= 1'b0;

            if (state == RECEIVE) begin
                // Shift right, shift in LSB-first serial bit into MSB: new bit goes to shift_reg[7]
                // This accumulates bits LSB first in shift_reg[0] after 8 shifts
                shift_reg <= {in, shift_reg[7:1]};
                bit_count <= bit_count + 1'b1;
            end else begin
                bit_count <= 3'd0;
                shift_reg <= 8'd0;
            end

            if (state == CHECK_STOP && in == 1'b1) begin
                done <= 1'b1;
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                // After receiving 8 bits, go to CHECK_STOP
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                // Valid stop bit (1) -> IDLE, else wait for stop bit
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                // Wait until line returns to idle (1)
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule