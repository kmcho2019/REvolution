module TopModule (
    input  wire clk,
    input  wire aresetn,
    input  wire x,
    output reg  z
);

    // State encoding using typedef enum for readability
    typedef enum logic [1:0] {
        IDLE = 2'd0, // no match yet
        ONE  = 2'd1, // matched '1'
        TEN  = 2'd2  // matched '10'
    } state_t;

    state_t state, next_state;

    // Combinational logic for next state and output (Mealy output)
    always @(*) begin
        next_state = IDLE; // default
        z = 1'b0;          // default output

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
                if (x) begin
                    next_state = ONE;
                    z = 1'b1; // "101" detected here
                end else
                    next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
                z = 1'b0;
            end
        endcase
    end

    // Sequential logic for state with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= IDLE;
        else
            state <= next_state;
    end

endmodule