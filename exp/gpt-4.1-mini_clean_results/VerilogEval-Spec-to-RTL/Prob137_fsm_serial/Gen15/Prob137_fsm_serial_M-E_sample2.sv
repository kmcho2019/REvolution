module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding (3 bits binary)
    localparam [2:0]
        IDLE  = 3'd0,
        START = 3'd1,
        DATA  = 3'd2,
        STOP  = 3'd3,
        ERROR = 3'd4;

    reg [2:0] state, next_state;
    reg [7:0] shift_reg;
    reg [3:0] bit_count;  // 4 bits to count up to 8 data bits

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START;
            end
            START: begin
                // Confirm start bit still 0 on next cycle
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE; // False start, back to idle
            end
            DATA: begin
                if (bit_count == 4'd8)
                    next_state = STOP;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            ERROR: begin
                if (in == 1'b1)
                    next_state = IDLE; // Wait for stop bit line idle before restarting
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, data shift, counters, done pulse
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'd0;
            bit_count <= 4'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;

            case (state)
                IDLE: begin
                    shift_reg <= 8'd0;
                    bit_count <= 4'd0;
                end
                START: begin
                    // no data shift or count, just confirm start bit
                end
                DATA: begin
                    // Shift in LSB first: shift left, put new bit in LSB
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end
                STOP: begin
                    if (in == 1'b1)
                        done <= 1'b1; // pulse done on correct stop bit
                end
                ERROR: begin
                    // hold shift_reg and bit_count (or reset, but not strictly needed)
                    shift_reg <= 8'd0;
                    bit_count <= 4'd0;
                end
            endcase
        end
    end

endmodule