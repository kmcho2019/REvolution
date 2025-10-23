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
    localparam [2:0]
        IDLE    = 3'd0, // no bits matched
        S1      = 3'd1, // matched '1'
        S11     = 3'd2, // matched '11'
        S110    = 3'd3, // matched '110'
        SHIFT   = 3'd4, // shift 4 bits
        COUNT   = 3'd5, // counting
        DONE    = 3'd6; // done, wait ack

    reg [2:0] state, next_state;
    reg [1:0] shift_count;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            if(state == SHIFT)
                shift_count <= shift_count + 1'b1;
            else
                shift_count <= 2'd0;
        end
    end

    // Next state and outputs
    always @(*) begin
        // Default outputs
        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;
        next_state = state;

        case(state)
            IDLE: next_state = (data) ? S1 : IDLE;
            S1:   next_state = (data) ? S11 : IDLE;
            S11:  next_state = (data) ? S11 : S110;
            S110: next_state = (data) ? SHIFT : IDLE;

            SHIFT: begin
                shift_ena = 1'b1;
                next_state = (shift_count == 2'd3) ? COUNT : SHIFT;
            end

            COUNT: begin
                counting = 1'b1;
                next_state = done_counting ? DONE : COUNT;
            end

            DONE: begin
                done = 1'b1;
                next_state = ack ? IDLE : DONE;
            end
        endcase
    end

endmodule