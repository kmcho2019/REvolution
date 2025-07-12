module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // One-hot encoded states
    localparam IDLE          = 5'b00001;
    localparam ONE           = 5'b00010;
    localparam ONE_ONE       = 5'b00100;
    localparam ONE_ONE_ZERO  = 5'b01000;
    localparam MATCHED       = 5'b10000;

    reg [4:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        case (state)
            IDLE: begin
                if (data)
                    next_state = ONE;
                else
                    next_state = IDLE;
            end

            ONE: begin
                if (data)
                    next_state = ONE_ONE;
                else
                    next_state = IDLE;
            end

            ONE_ONE: begin
                if (data)
                    next_state = ONE_ONE;  // stay on ONE_ONE if input is 1 (handles overlapping)
                else
                    next_state = ONE_ONE_ZERO;
            end

            ONE_ONE_ZERO: begin
                if (data)
                    next_state = MATCHED;  // sequence 1101 matched
                else
                    next_state = IDLE;
            end

            MATCHED: begin
                // Remain in MATCHED state forever after detection
                next_state = MATCHED;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: update state and output with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (next_state == MATCHED)
                start_shifting <= 1'b1;
            // once set, start_shifting stays 1 forever until reset
        end
    end

endmodule