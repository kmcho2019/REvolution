module TopModule (
    input  wire clk,
    input  wire aresetn,  // asynchronous negative edge reset
    input  wire x,
    output reg  z
);

    // One-hot state encoding
    localparam
        IDLE = 3'b001, // no bits matched
        ONE  = 3'b010, // matched '1'
        TEN  = 3'b100; // matched "10"

    reg [2:0] state, next_state;

    // Asynchronous negative edge reset, synchronous state update
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Combined next state and output logic (Mealy FSM)
    always @(*) begin
        // Defaults
        next_state = state;
        z = 1'b0;

        case (state)
            IDLE: begin
                if (x)
                    next_state = ONE;
                else
                    next_state = IDLE;
                z = 1'b0;
            end

            ONE: begin
                if (x) begin
                    next_state = ONE;
                    z = 1'b0;
                end else begin
                    next_state = TEN;
                    z = 1'b0;
                end
            end

            TEN: begin
                if (x) begin
                    next_state = ONE;
                    z = 1'b1; // sequence "101" detected here (TEN + x=1)
                end else begin
                    next_state = IDLE;
                    z = 1'b0;
                end
            end

            default: begin
                next_state = IDLE;
                z = 1'b0;
            end
        endcase
    end

endmodule