module TopModule (
    input  wire clk,
    input  wire aresetn,  // asynchronous negative edge reset
    input  wire x,
    output reg  z
);

    // State encoding
    localparam [1:0]
        IDLE = 2'b00, // No bits matched yet
        ONE  = 2'b01, // matched '1'
        TEN  = 2'b10; // matched "10"

    reg [1:0] state, next_state;

    // Asynchronous negative edge reset, synchronous state update
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        // Default to stay in current state to avoid inferred latches
        next_state = state;

        case (state)
            IDLE: begin
                if (x)
                    next_state = ONE;
                else
                    next_state = IDLE;
            end

            ONE: begin
                if (x)
                    next_state = ONE;
                else
                    next_state = TEN;
            end

            TEN: begin
                if (x)
                    next_state = ONE;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic (combinational Mealy output)
    always @(*) begin
        z = (state == TEN) && x;
    end

endmodule