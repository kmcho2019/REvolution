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
    localparam IDLE   = 2'd0;
    localparam SHIFT  = 2'd1;
    localparam COUNT  = 2'd2;
    localparam DONE   = 2'd3;

    reg [1:0] state, next_state;
    reg [1:0] shift_count;
    reg [3:0] pattern_shift;

    // Pattern detection and shift counter update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 2'd0;
            pattern_shift <= 4'd0;
        end else begin
            pattern_shift <= {pattern_shift[2:0], data};
            state <= next_state;
            if (state == SHIFT)
                shift_count <= shift_count + 2'd1;
            else
                shift_count <= 2'd0;
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:   next_state = (pattern_shift == 4'b1101) ? SHIFT : IDLE;
            SHIFT:  next_state = (shift_count == 2'd3) ? COUNT : SHIFT;
            COUNT:  next_state = done_counting ? DONE : COUNT;
            DONE:   next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Outputs
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule