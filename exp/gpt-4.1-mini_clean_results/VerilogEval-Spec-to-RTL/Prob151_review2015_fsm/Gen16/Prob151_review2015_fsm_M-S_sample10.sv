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

    // State encoding
    localparam S0      = 3'd0; // no match
    localparam S1      = 3'd1; // matched '1'
    localparam S11     = 3'd2; // matched '11'
    localparam S110    = 3'd3; // matched '110'
    localparam SHIFT   = 3'd4; // shift in 4 bits
    localparam COUNT   = 3'd5; // counting
    localparam DONE    = 3'd6; // done, wait ack

    reg [2:0] state, next_state;
    reg [1:0] shift_count;

    // Next state logic
    always @(*) begin
        case (state)
            S0:     next_state = data ? S1   : S0;
            S1:     next_state = data ? S11  : S0;
            S11:    next_state = data ? S11  : S110;
            S110:   next_state = data ? SHIFT: S0;
            SHIFT:  next_state = (shift_count == 2'd3) ? COUNT : SHIFT;
            COUNT:  next_state = done_counting ? DONE : COUNT;
            DONE:   next_state = ack ? S0 : DONE;
            default: next_state = S0;
        endcase
    end

    // Sequential state and shift_count logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            if (state == SHIFT)
                shift_count <= shift_count + 1'b1;
            else
                shift_count <= 2'd0;
        end
    end

    // Outputs (Moore)
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule