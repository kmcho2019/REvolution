module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding
    localparam S0  = 3'd0; // 0 consecutive ones
    localparam S1  = 3'd1; // 1 consecutive one
    localparam S2  = 3'd2; // 2 consecutive ones
    localparam S3  = 3'd3; // 3 consecutive ones
    localparam S4  = 3'd4; // 4 consecutive ones
    localparam S5  = 3'd5; // 5 consecutive ones
    localparam S6  = 3'd6; // 6 consecutive ones
    localparam ERR = 3'd7; // error (7 or more ones)

    reg [2:0] state, next_state;

    // Moore outputs depend on state only
    reg disc_next, flag_next, err_next;

    // State transition logic
    always @(*) begin
        disc_next = 1'b0;
        flag_next = 1'b0;
        err_next  = 1'b0;
        next_state = state;

        case(state)
            S0: begin
                if(in) next_state = S1;
                else   next_state = S0;
            end

            S1: begin
                if(in) next_state = S2;
                else   next_state = S0;
            end

            S2: begin
                if(in) next_state = S3;
                else   next_state = S0;
            end

            S3: begin
                if(in) next_state = S4;
                else   next_state = S0;
            end

            S4: begin
                if(in) next_state = S5;
                else   next_state = S0;
            end

            S5: begin
                if(in) next_state = S6;
                else   next_state = S0;
            end

            S6: begin
                if(in) next_state = ERR;
                else   next_state = S0;
            end

            ERR: begin
                // Stay in error state until reset
                next_state = ERR;
            end

            default: begin
                next_state = S0;
            end
        endcase

        // Outputs asserted based on state and next input pattern, delayed one cycle (Moore)
        // Because outputs are pure Moore, they depend on current state only
        // We will assert outputs in states corresponding to detected patterns on previous input

        // disc is asserted when we saw exactly five consecutive ones followed by a zero:
        // That means the state was S5 and next input is zero, so output disc next cycle in S5 state.
        if(state == S5)
            disc_next = 1'b1;

        // flag is asserted when exactly six consecutive ones followed by a zero:
        // That corresponds to state S6.
        if(state == S6)
            flag_next = 1'b1;

        // err asserted in error state
        if(state == ERR)
            err_next = 1'b1;
    end

    // Sequential block: update state and outputs with synchronous reset
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