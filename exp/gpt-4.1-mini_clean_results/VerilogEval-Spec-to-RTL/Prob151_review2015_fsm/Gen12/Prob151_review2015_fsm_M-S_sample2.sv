module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output reg  shift_ena,
    output reg  counting,
    output reg  done
);

    // States
    localparam [1:0]
        WAIT  = 2'd0, // pattern detection
        SHIFT = 2'd1, // shifting 4 bits
        COUNT = 2'd2, // counting
        DONE  = 2'd3; // done, waiting for ack

    reg [1:0] state, next_state;
    reg [1:0] shift_count;
    reg [3:0] pattern_reg; // to detect 4-bit pattern

    // Pattern detection shift register
    always @(posedge clk) begin
        if (reset)
            pattern_reg <= 4'd0;
        else if (state == WAIT)
            pattern_reg <= {pattern_reg[2:0], data};
    end

    // State register and shift_count with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            if (state == SHIFT)
                shift_count <= shift_count + 2'd1;
            else
                shift_count <= 2'd0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            WAIT:
                if (pattern_reg == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = WAIT;
            SHIFT:
                next_state = (shift_count == 2'd3) ? COUNT : SHIFT;
            COUNT:
                next_state = done_counting ? DONE : COUNT;
            DONE:
                next_state = ack ? WAIT : DONE;
            default:
                next_state = WAIT;
        endcase
    end

    // Outputs: Moore type
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule