module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // FSM states representing count of consecutive ones: 0 to 6, plus error state (7)
    typedef enum logic [3:0] {
        S0 = 4'd0, // zero consecutive ones
        S1 = 4'd1,
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,
        S6 = 4'd6,
        S_ERR = 4'd7
    } state_t;

    state_t state, next_state;

    // Moore outputs depend on state only
    reg disc_next, flag_next, err_next;

    // Next state and output logic
    always @(*) begin
        // Default outputs
        disc_next = 1'b0;
        flag_next = 1'b0;
        err_next  = 1'b0;

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
                else begin
                    next_state = S0;
                    // Received zero after 5 ones -> discard inserted zero bit
                    disc_next = 1'b1;
                end
            end
            S6: begin
                if (in) begin
                    next_state = S_ERR;
                    // Seven or more ones -> error
                    err_next = 1'b1;
                end else begin
                    next_state = S0;
                    // Received zero after 6 ones -> flag detected
                    flag_next = 1'b1;
                end
            end
            S_ERR: begin
                // Stay in error state as long as input is 1
                if (in) begin
                    next_state = S_ERR;
                    err_next = 1'b1;
                end else begin
                    // Recover when zero is received
                    next_state = S0;
                end
            end
            default: begin
                next_state = S0;
            end
        endcase
    end

    // Sequential logic: update state and outputs synchronously
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            disc  <= disc_next;
            flag  <= flag_next;
            err   <= err_next;
        end
    end

endmodule