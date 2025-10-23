module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // One-hot state encoding
    localparam IDLE   = 5'b00001;
    localparam S1     = 5'b00010;
    localparam S11    = 5'b00100;
    localparam S110   = 5'b01000;
    localparam DETECT = 5'b10000;

    reg [4:0] state, next_state;

    always @(*) begin
        // Default next state is current state to hold
        next_state = state;

        case (state)
            IDLE: begin
                if (data)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            S1: begin
                if (data)
                    next_state = S11;
                else
                    next_state = IDLE;
            end
            S11: begin
                if (data)
                    next_state = S11;
                else
                    next_state = S110;
            end
            S110: begin
                if (data)
                    next_state = DETECT;
                else
                    next_state = IDLE;
            end
            DETECT: begin
                // Stay in DETECT once sequence found
                next_state = DETECT;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state and output update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // Start shifting is latched high after detection
            // It is set when entering DETECT state
            if (next_state == DETECT)
                start_shifting <= 1'b1;
        end
    end

endmodule