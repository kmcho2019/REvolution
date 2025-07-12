module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // Define states as parameters for clarity
    typedef enum reg [3:0] {
        S0    = 4'd0,  // zero consecutive ones (or after reset)
        S1    = 4'd1,
        S2    = 4'd2,
        S3    = 4'd3,
        S4    = 4'd4,
        S5    = 4'd5,
        S6    = 4'd6,
        DISC  = 4'd7,  // output disc=1 for one cycle
        FLAG  = 4'd8,  // output flag=1 for one cycle
        ERROR = 4'd9   // output err=1 continuously until reset or input=0
    } state_t;

    state_t state, next_state;

    // Next state combinational logic
    always @(*) begin
        // Default next state is current (hold)
        next_state = state;
        case (state)
            S0: begin
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (in)
                    next_state = S2;
                else
                    next_state = S0;
            end
            S2: begin
                if (in)
                    next_state = S3;
                else
                    next_state = S0;
            end
            S3: begin
                if (in)
                    next_state = S4;
                else
                    next_state = S0;
            end
            S4: begin
                if (in)
                    next_state = S5;
                else
                    next_state = S0;
            end
            S5: begin
                if (in)
                    next_state = S6;
                else
                    next_state = DISC; // disc output next cycle (after 5 ones then zero)
            end
            S6: begin
                if (in)
                    next_state = ERROR; // 7 or more ones, error immediately
                else
                    next_state = FLAG;  // flag output next cycle (after 6 ones then zero)
            end
            DISC: begin
                // disc asserted one cycle, then return to S0
                next_state = S0;
            end
            FLAG: begin
                // flag asserted one cycle, then return to S0
                next_state = S0;
            end
            ERROR: begin
                // Remain in error until reset or input=0 to recover
                if (in == 1'b0)
                    next_state = S0;
                else
                    next_state = ERROR;
            end
            default: next_state = S0;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // Outputs depend only on current state (Moore)
            disc <= (next_state == DISC);
            flag <= (next_state == FLAG);
            err  <= (next_state == ERROR);
        end
    end

endmodule