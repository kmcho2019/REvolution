module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    typedef enum logic [3:0] {
        S0        = 4'd0,  // 0 consecutive ones
        S1        = 4'd1,
        S2        = 4'd2,
        S3        = 4'd3,
        S4        = 4'd4,
        S5        = 4'd5,
        S5_disc   = 4'd6,  // output disc = 1 for one cycle
        S6        = 4'd7,
        S6_flag   = 4'd8,  // output flag = 1 for one cycle
        S7        = 4'd9   // error state (7 or more ones)
    } state_t;

    state_t state, next_state;

    // Combinational next state logic
    always @(*) begin
        next_state = state; // default hold

        case(state)
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
                    next_state = S5_disc; // go to output disc state
            end
            S5_disc: begin
                next_state = S0; // after disc output cycle, reset count
            end
            S6: begin
                if (in)
                    next_state = S7; // error: 7 or more ones
                else
                    next_state = S6_flag; // go to output flag state
            end
            S6_flag: begin
                next_state = S0; // after flag output cycle, reset count
            end
            S7: begin
                if (!in)
                    next_state = S0; // zero resets error count
                else
                    next_state = S7; // remain error
            end
            default: begin
                next_state = S0;
            end
        endcase
    end

    // Sequential logic: state and outputs update on clk posedge
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // Outputs are purely Moore outputs, depend only on the current state
            disc <= (state == S5_disc);
            flag <= (state == S6_flag);
            err  <= (state == S7);
        end
    end

endmodule