module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // Define FSM states for consecutive ones count
    typedef enum reg [3:0] {
        IDLE  = 4'd0,  // no consecutive ones
        S1    = 4'd1,
        S2    = 4'd2,
        S3    = 4'd3,
        S4    = 4'd4,
        S5    = 4'd5,
        S6    = 4'd6,
        ERROR = 4'd7
    } state_t;

    state_t state, next_state;

    // Combinational logic: determine next state based on input and current state
    always @(*) begin
        // Default no outputs asserted
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;
        next_state = state;

        case(state)
            IDLE: begin
                if (in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            S1: begin
                if (in)
                    next_state = S2;
                else begin
                    // zero after 1 one: no special output
                    next_state = IDLE;
                end
            end

            S2: begin
                if (in)
                    next_state = S3;
                else begin
                    // zero after 2 ones: no special output
                    next_state = IDLE;
                end
            end

            S3: begin
                if (in)
                    next_state = S4;
                else begin
                    // zero after 3 ones: no special output
                    next_state = IDLE;
                end
            end

            S4: begin
                if (in)
                    next_state = S5;
                else begin
                    // zero after 4 ones: no special output
                    next_state = IDLE;
                end
            end

            S5: begin
                if (in)
                    next_state = S6;
                else begin
                    // zero after 5 ones: discard bit (disc)
                    disc = 1'b1;
                    next_state = IDLE;
                end
            end

            S6: begin
                if (in)
                    next_state = ERROR;
                else begin
                    // zero after 6 ones: flag
                    flag = 1'b1;
                    next_state = IDLE;
                end
            end

            ERROR: begin
                // Once in error state, stay here if input continues to be 1 or zero
                err = 1'b1;
                if (in)
                    next_state = ERROR;
                else
                    next_state = IDLE; // reset count after zero input
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Sequential logic: register state and outputs, synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            // Outputs are assigned in combinational block so must be registered here
            // Register disc, flag, err only on clock edge
            disc  <= disc;
            flag  <= flag;
            err   <= err;
        end
    end

endmodule